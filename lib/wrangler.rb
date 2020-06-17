# frozen_string_literal: true

require 'json'

class Wrangler
  require 'net/http'

  def self.call_api(barcodes)
    responses = []

    begin
      barcodes.each do |barcode|
        url = URI.parse("#{Rails.application.config.wrangler_url}/#{barcode}")

        Rails.logger.debug("Trying POST to: #{url}")

        req = Net::HTTP::Post.new(url.to_s)

        res = Net::HTTP.start(url.host, url.port) do |http|
          http.request(req)
        end
        responses << { barcode: barcode, code: res.code, json: JSON.parse(res.body)}
      end
    rescue StandardError => e
      Rails.logger.error(e)
      nil
    else
      Rails.logger.info('Sent POST requests to wrangler')
      Rails.logger.info("Responses: #{responses}")
    end
    responses
  end
end
