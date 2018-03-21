# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    module Files
      module Practices
        class ConvertXmlToCsv
          PRACTICE_ROLES = %w(RO177 RO76).freeze

          def self.call(xml_path)
            new.call(xml_path)
          end

          # Returns path to converted CSV file
          def call(xml_path)
            create_practice_csv_from_organisation_xml(xml_path)
          end

          private

          def create_practice_csv_from_organisation_xml(xml_path)
            file = CSVFile.new(dir: xml_path.dirname).create do |csv_writer|
              build_practice_csv_from_organisation_xml(xml_path, csv_writer)
            end
            Pathname(file)
          end

          # While processing the XML using the Nokogiri Read API (wrapper by our XmlParser class)
          # the memory footprint of the app does not rise which is the important thing here as the
          # HSCorg XML file is around 400MB. This because we have not loaded the
          # XML into memory (which would cause memory usage to spike over 1GB) but instead
          # are walking over the elements. Its slower than SAX which is an alternative, as we have
          # to inspect every Organisation in in the file even though we only want a subset of them,
          # but its very easy to read.
          # Currently takes around 3 minutes as a background job.
          # Be careful when handling elements that can appear in > 1 place - e.g. Status - and
          # check the @node.depth.
          #
          # There are alternative ways to parse the XML. TRUD provide an XSLT style-sheet which can
          # extract orgs with a specific primary role (RO76 in our case) to build another XML
          # document; they provide another XSLT for parsing the XML into CSV files. However they
          # split the CSV files (a separate one for contact details for example), and do not not
          # run on Mac/Linux without modification (they expect to be run on Windows).
          #
          # Note that the Countries in the file (with current org counts) are as follows:
          # - ENGLAND (178568)
          # - WALES (7013)
          # - SCOTLAND (95)
          # - NORTHERN IRELAND (19)
          # - CHANNEL ISLANDS (57)
          # - ISLE OF MAN (169)
          #
          # We must map the first 4 to "United Kingdom", and store e.g. Wales in address.region
          # The others are genuine countries and left as such
          #
          # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
          # rubocop:disable Metrics/CyclomaticComplexity
          def build_practice_csv_from_organisation_xml(xml_path, csv_writer)
            Rails.logger.warn "Converting XML to CSV"
            practices_count = 0
            regions = Hash.new(0)
            # uk = System::Country.find_by(alpha3: "GBR")
            countries = System::Country.all

            XmlParser.new(Nokogiri::XML::Reader(open(xml_path))) do
              org = CSVOrganisation.new
              org.roles = []

              direct_child_of_org_element = -> { @node.depth == 3 }

              inside_element "Organisation" do
                for_element "Name" do org.name = inner_xml end

                for_element "Status" do
                  # We need to check the depth of this Status element: if it is 3 we are directly
                  # under the Organisation so that's good. Otherwise we are deeper in, probably a
                  # role status, so ignore those.
                  if direct_child_of_org_element.call
                    org.active = attribute("value")&.downcase == "active"
                  end
                end

                # Be sure not to pick up OrgId nodes under e.g. Target
                for_element "OrgId" do
                  if direct_child_of_org_element.call
                    org.code = attribute("extension")
                  end
                end

                inside_element "Contacts" do
                  for_element "Contact" do
                    org.telephone = attribute("value") if @node.attribute("type") == "tel"
                  end
                end
                inside_element "GeoLoc" do
                  inside_element "Location" do
                    for_element "AddrLn1" do org.street_1 = inner_xml end
                    for_element "AddrLn2" do org.street_2 = inner_xml end
                    for_element "AddrLn3" do org.street_3 = inner_xml end
                    for_element "Town" do org.city = inner_xml end
                    for_element "County" do org.county = inner_xml end
                    for_element "PostCode" do org.postcode = inner_xml end
                    for_element "Country" do
                      country_name = inner_xml

                      CountryMap.new.map(country_name).tap do |mapped|
                        org.region = mapped.region
                        found_country = countries.find_by(name: mapped.country)
                        if found_country.blank?
                          Rails.logger.warn("#{country_name} not mapped")
                          org.skip = true
                          org.region = country_name
                          # raise(CountryNotFoundError, country_name)
                        else
                          org.country_id = found_country.id
                        end
                      end
                    end
                  end
                end
                inside_element "Roles" do
                  for_element "Role" do org.roles << @node.attribute("id") end
                end
              end

              if (PRACTICE_ROLES & org.roles).any?
                fail unless org.code&.length == 6
                practices_count += 1
                if org.skip
                  Rails.logger.warn(
                    "Not importing practice, probably because country country_name not found. "\
                    "#{org}"
                  )
                else
                  csv_writer << org.to_a
                end
              end
            end
            Rails.logger.warn "Found regions #{regions}"
            Rails.logger.warn "Found #{practices_count} practices with role RO76"
          end

          class CountryNotFoundError < StandardError; end
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
      end
    end
  end
end
