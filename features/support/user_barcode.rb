require File.expand_path(File.join(File.dirname(__FILE__), 'fake_sinatra_service.rb'))
require 'webmock/cucumber'
class FakeUserBarcodeService
  include Singleton
  # Ensure that the configuration is maintained, otherwise things start behaving badly
  # when it comes to the features.
  def self.install_hooks(target, tags)
    target.instance_eval do
      Before(tags) do |_scenario|
        user_barcode_uri = URI.parse(Settings.settings['user_barcode_url'])
        stub_request(:get, "#{user_barcode_uri.host}:#{user_barcode_uri.port}/user_barcodes/lookup_scanned_barcode.xml").to_return do
          user = FakeUserBarcodeService.instance.find_username_from_barcode(params[:barcode])
          content = { 'login' => user, 'barcode' => params[:barcode] }
          {
            headers: { 'Content-Type' => 'application/xml' },
            body: content.to_xml(root: 'user_barcodes')
          }
        end
      end

      After(tags) do |_scenario|
        FakeUserBarcodeService.instance.clear
      end
    end
  end

  def user_barcodes
    @user_barcodes ||= {}
  end

  def clear
    @user_barcodes = {}
  end

  def user_barcode(user, barcode)
    user_barcodes[barcode] = user
  end

  def find_username_from_barcode(barcode)
    user_barcodes[barcode]
  end
end

FakeUserBarcodeService.install_hooks(self, '@user_barcode_service')
