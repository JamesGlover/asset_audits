# frozen_string_literal: true

namespace :lysates_extraction_hamilton do
  SRC_BEDS = %w(580000004838 580000005699)
  DEST_BEDS = %w(580000034668 580000035672)
  SRC_BED_NUMS = %w(4 5)
  DEST_BED_NUMS = %w(34 35)

  task add: :environment do
    ActiveRecord::Base.transaction do
      # create robot instrument and the lysates process
      instrument_hamilton = Instrument.find_or_create_by!(name: 'Hamilton Star 6', barcode: '4880000067878')
      instrument_process = InstrumentProcess.find_or_create_by!(name: 'Lysates Extraction', key: 'lysates_extraction')
      InstrumentProcessesInstrument.find_or_create_by!(
        instrument: instrument_hamilton,
        instrument_process: instrument_process,
        bed_verification_type: 'Verification::DilutionPlate::Hamilton'
      )

      # create robot beds
      SRC_BEDS.each_with_index.map do |bc, index|
        Bed.find_or_create_by!({ name: "SCRC#{SRC_BED_NUMS[index]}",
                      bed_number: SRC_BED_NUMS[index],
                      barcode: bc,
                      instrument: instrument_hamilton })
      end
      DEST_BEDS.each_with_index.map do |bc, index|
        Bed.find_or_create_by!({ name: "DEST#{DEST_BED_NUMS[index]}",
                      bed_number: DEST_BED_NUMS[index],
                      barcode: bc,
                      instrument: instrument_hamilton })
      end
    end
  end

  task remove: :environment do
    ActiveRecord::Base.transaction do
      instrument_process = InstrumentProcess.find_by_key('lysates_extraction')
      instrument_processes_instruments = instrument_process.instrument_processes_instruments
      instrument_processes_instruments.each(&:destroy!)
      instrument_process.destroy!
    end
  end
end
