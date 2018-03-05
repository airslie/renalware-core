# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/ModuleLength
require "rails_helper"

module Renalware
  module Feeds
    module Files
      module Practices
        describe ImportCSV do
          let(:uk) { create(:united_kingdom) }

          def csv_content(uk_id:)
            "code,name,telephone,street_1,street_2,street_3,city,county,postcode,region,country_id,active\n" \
            "J82022,VICTOR STREET SURGERY,023 80706919,VICTOR STREET,UPPER SHIRLEY,,SOUTHAMPTON,HAMPSHIRE,SO15 5SY,ENGLAND,#{uk_id},true\n" \
            "Y04927,CULCHETH PRIMARY CARE CENTRE,01925 765349,JACKSON AVENUE,CULCHETH,,WARRINGTON,CHESHIRE,WA3 4DZ,ENGLAND,#{uk_id},false\n"
          end

          def with_tmpfile(content)
            tmpfile = Tempfile.new("test_csv")
            tmpfile.write(content)
            tmpfile.rewind
            yield Pathname(tmpfile)
          ensure
            tmpfile.close
            tmpfile.unlink
          end

          it "imports the practice and its address correctly" do
            pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
            csv_content =
              "code,name,telephone,street_1,street_2,street_3,city,county,postcode,region,country_id,active\n" \
              "A11111,SURGERY A,0111 1111111,STREET A,SOME TOWN,,CITY A,COUNTY A,AO11 11A,ENGLAND,#{uk.id},true\n"

            with_tmpfile(csv_content) do |tmpfile|
              expect{
                described_class.new(tmpfile).call
              }
              .to change{ Patients::Practice.count }.by(1)
              .and change{ Patients::Practice.deleted.count }.by(0)

              practice = Patients::Practice.first
              expect(practice.name).to eq("SURGERY A")
              expect(practice.code).to eq("A11111")
              expect(practice.deleted_at).to be_nil
              expect(practice.telephone).to eq("0111 1111111")
              expect(practice.address.to_s).to eq(
                "STREET A, SOME TOWN, CITY A, COUNTY A, AO11 11A, United Kingdom"
              )
            end
          end

          context "when a practice is not active" do
            it "is marked as deleted" do
              pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
              csv_content =
                "code,name,telephone,street_1,street_2,street_3,city,county,postcode,region,country_id,active\n" \
                "A11111,SURGERY A,0111 1111111,STREET A,SOME TOWN,,CITY A,COUNTY A,AO11 11A,ENGLAND,#{uk.id},false\n"

              with_tmpfile(csv_content) do |tmpfile|
                expect{
                  described_class.new(tmpfile).call
                }
                .to change{ Patients::Practice.count }.by(0)
                .and change{ Patients::Practice.deleted.count }.by(1)

                practice = Patients::Practice.deleted.last
                expect(practice.name).to eq("SURGERY A")
                expect(practice.address.to_s).to eq(
                  "STREET A, SOME TOWN, CITY A, COUNTY A, AO11 11A, United Kingdom"
                )
              end
            end
          end

          context "when a practice was previously active but becomes inactive" do
            it "soft deletes it" do
              pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
              create(:practice, code: "A11111")
              csv_content =
                "code,name,telephone,street_1,street_2,street_3,city,county,postcode,region,country_id,active\n" \
                "A11111,SURGERY A,0111 1111111,STREET A,SOME TOWN,,CITY A,COUNTY A,AO11 11A,ENGLAND,#{uk.id},false\n"

              with_tmpfile(csv_content) do |tmpfile|
                expect{
                  described_class.new(tmpfile).call
                }
                .to change{ Patients::Practice.count }.by(-1)
                .and change{ Patients::Practice.deleted.count }.by(1)
              end
            end
          end

          context "when a practice was previously inactive but becomes active" do
            it "it removes the soft delete" do
              pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
              create(:practice, code: "A11111", deleted_at: 1.day.ago)

              csv_content =
                "code,name,telephone,street_1,street_2,street_3,city,county,postcode,region,country_id,active\n" \
                "A11111,SURGERY A,0111 1111111,STREET A,SOME TOWN,,CITY A,COUNTY A,AO11 11A,ENGLAND,#{uk.id},true\n"

              with_tmpfile(csv_content) do |tmpfile|
                expect{
                  described_class.new(tmpfile).call
                }
                .to change{ Patients::Practice.count }.by(1)
                .and change{ Patients::Practice.deleted.count }.by(-1)
              end
            end
          end

          context "when a practice existed buy new import file changes its properties" do
            it "updates appropriate properties" do
              pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
              practice = create(
                :practice,
                code: "A11111",
                name: "ABC",
                telephone: "0000000"
              )
              practice.address.postcode = "XYZ"

              csv_content =
                "code,name,telephone,street_1,street_2,street_3,city,county,postcode,region,country_id,active\n" \
                "A11111,SURGERY A,0111 1111111,STREET A,SOME TOWN,,CITY A,COUNTY A,AO11 11A,ENGLAND,#{uk.id},true\n"

              with_tmpfile(csv_content) do |tmpfile|
                expect{
                  described_class.new(tmpfile).call
                }
                .to change{ Patients::Practice.count }.by(0)
                .and change{ Patients::Practice.deleted.count }.by(0)
              end

              expect(practice.reload.name).to eq("SURGERY A")
              expect(practice.address.to_s).to eq(
                "STREET A, SOME TOWN, CITY A, COUNTY A, AO11 11A, United Kingdom"
              )
            end
          end
        end
      end
    end
  end
end
