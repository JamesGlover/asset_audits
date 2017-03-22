# Handles the transfer of one source plate onto multiple destination plates.
# 1. All destination beds must have something on them
# 2. Source and destination plates must be linked.
class Verification::AssayPlate::Base < Verification::Base
  include Verification::BedVerification
  validates_with Verification::Validator::SourceAndDestinationPlatesScanned
  validates_with Verification::Validator::AllDestinationPlatesScanned

  def self.partial_name
    'assay_plate'
  end

  def self.javascript_partial_name
    'nx_assay_plate_javascript'
  end

  def parse_source_and_destination_barcodes(scanned_values)
    source_and_destination_barcodes = []
    source_barcode = scanned_values[source_beds.first.downcase.to_sym][:plate]
    return [] if source_barcode.blank?

    destination_beds.each do |destination_bed|
      destination_barcode = scanned_values[destination_bed.downcase.to_sym][:plate]
      next if destination_barcode.blank?
      source_and_destination_barcodes << [source_barcode, destination_barcode]
    end

    source_and_destination_barcodes
  end
end
