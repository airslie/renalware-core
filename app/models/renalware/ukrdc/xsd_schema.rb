# frozen_string_literal: true

module Renalware
  module UKRDC
    class XsdSchema
      def validate(xml)
        schema.validate(Nokogiri::XML(xml))
      end

      private

      def schema
        @schema ||= begin
          xsd_path = File.join(Renalware::Engine.root, "vendor/xsd/ukrdc/Schema/UKRDC.xsd")
          xsddoc = Nokogiri::XML(File.read(xsd_path), xsd_path)
          Nokogiri::XML::Schema.from_document(xsddoc)
        end
      end
    end
  end
end
