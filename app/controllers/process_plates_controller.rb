# frozen_string_literal: true
class ProcessPlatesController < ApplicationController
  require 'wrangler'
  require 'lighthouse'

  skip_before_filter :configure_api, except: [:create]

  attr_accessor :messages

  def index
  end

  def new
    @processes_requiring_visual_check = InstrumentProcess.where(visual_check_required: true).pluck(:id)
    @process_plate = ProcessPlate.new
  end

  def create
    # respond_to do |format|
      bed_verification_model = InstrumentProcessesInstrument.get_bed_verification_type(params[:instrument_barcode], params[:instrument_process])
      if bed_verification_model.nil?
        flash[:error] = 'Invalid instrument or process'
      else
        bed_layout_verification = bed_verification_model.new(
          instrument_barcode: params[:instrument_barcode],
          scanned_values: params[:robot],
          api: api
        )
        if bed_layout_verification.validate_and_create_audits?(params)
          # the param is called 'source_plates' but we could be working with tube racks or plates etc.
          barcodes = sanitize_barcodes(params[:source_plates])

          # find out if the 'receive_plates' process was executed
          receive_plates_process = InstrumentProcess.find_by(id: params[:instrument_process]).key.eql?('slf_receive_plates')

          message = ''
          if barcodes && receive_plates_process
            call_external_services(barcodes)

            message = @lighthouse_responses.concat(@wrangler_responses)
          end

          # TODO: display the responses from the services in a partial, not a flash
          # TODO: sort out original flash code below
          flash[:notice] = message

          # add a flash on the page for the number of unique barcodes scanned in
          # num_unique_barcodes = bed_layout_verification.process_plate&.barcodes.uniq.length
          # if num_unique_barcodes
          #   flash[:notice] = "Success - #{num_unique_barcodes} unique plate(s) scanned"
          # else
          #   flash[:notice] = "Success"
          # end
        else
          flash[:error] = bed_layout_verification.errors.values.flatten.join("\n")
        end
      end
      @results = parse_responses
      render :results
    # end
  end

  # Call any external services - currently lighthouse service for plates from Lighthouse Labs and
  #   wrangler for tube racks. If no samples are found in the lighthouse service, try the wrangler
  def call_external_services(barcodes)
    puts "DEBUG: call_external_services"
    # call the lighthouse service first as we are assuming that most labware scanned will be
    #   plates from Lighthouse Labs
    @lighthouse_responses = Lighthouse.call_api(barcodes)
    puts "DEBUG: lighthouse_responses: #{@lighthouse_responses}"

    # keeping it simple for now, if all the responses are not CREATED, send ALL the barcodes
    #   to the wrangler
    @wrangler_responses = Wrangler.call_api(barcodes) unless all_created?(@lighthouse_responses)
    puts "DEBUG: wrangler_responses: #{@wrangler_responses}"
  end

  # Returns a list of unique barcodes by removing blanks and duplicates
  def sanitize_barcodes(barcodes)
    barcodes.split(/\s+/).reject(&:blank?).compact.uniq
  end

  # Checks a list of responses if they are all CREATED (201)
  def all_created?(responses)
    return false if responses.empty?

    responses.all? { |response| response[:code] == "201" }
  end

  def parse_responses
    output = []

    @lighthouse_responses.each do |r|

      barcode = r[:barcode]
      success = if r[:code] == '201'
                  'Yes'
                else
                  'No'
                end
      purpose = r[:purpose]
      study = r[:study]

      output << {
        :barcode => barcode,
        :success => success,
        :purpose => purpose,
        :study => study
      }
    end

    @wrangler_responses.each do |r|

      barcode = r[:barcode]
      success = if r[:code] == '201'
                  'Yes'
                else
                  'No'
                end
      purpose = r[:purpose]
      study = r[:study]

      output << {
        :barcode => barcode,
        :success => success,
        :purpose => purpose,
        :study => study
      }
    end

    output
  end
end
