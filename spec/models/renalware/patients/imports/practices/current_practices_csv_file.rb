# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    module Imports
      module Practices
        describe CurrentPracticesCSVFile do
          PRACTICE_CODE = "A81001".freeze

          def active_practice_row
            practice_csv_row(practice_code: PRACTICE_CODE, status_code: "A")
          end

          def closed_practice_row
            practice_csv_row(practice_code: PRACTICE_CODE, status_code: "C")
          end

          def practice_csv_row(practice_code:, status_code:)
            '"' + practice_code + '","THE DENSHAM SURGERY","Y54","Q74",'\
            '"THE HEALTH CENTRE","LAWSON STREET","STOCKTON-ON-TEES","CLEVELAND","","TS18 1HU",'\
            '"19740401","","' + status_code + '","B","00K","20130401",'\
            '"","01642 672351","","","","0","","00K","","4",""'
          end

          def malformed_practice_row
            '"some","thing","is","wrong"'
          end

          def mock_csv_open(pathname:, contents:)
            expect(File)
              .to receive(:open)
              .with(pathname, universal_newline: false, headers: false) { StringIO.new(contents) }
          end

          def dummy_pathname
            Pathname.new(__FILE__)
          end

          describe "#call" do
            it "raises an error if the CSV file is not in the expected format" do
              mock_csv_open(pathname: dummy_pathname, contents: malformed_practice_row)
              expect{
                CurrentPracticesCSVFile.new(dummy_pathname).import
              }.to raise_error(Exceptions::UnexpectedCSVFormatError)
            end

            it "can import a single practice" do
              mock_csv_open(pathname: dummy_pathname, contents: active_practice_row)

              expect{
                CurrentPracticesCSVFile.new(dummy_pathname).import
              }.to change{ Practice.count }.by(1)
               .and change{ Address.count }.by(1)

              practice = Practice.first
              expect(practice.code).to eq(PRACTICE_CODE)
              expect(practice.name).to eq("THE DENSHAM SURGERY")

              address = practice.address
              expect(address.street_1).to eq("THE HEALTH CENTRE")
              expect(address.street_2).to eq("LAWSON STREET")
              expect(address.city).to eq("STOCKTON-ON-TEES")
              expect(address.county).to eq("CLEVELAND")
              expect(address.postcode).to eq("TS18 1HU")
            end

            it "does not import a practice if it is not active" do
              mock_csv_open(pathname: dummy_pathname, contents: closed_practice_row)
              expect{
                CurrentPracticesCSVFile.new(dummy_pathname).import
              }.to_not change{ Practice.count }
            end

            it "soft deletes an existing practice if its status has changed away from 'active'" do
              mock_csv_open(pathname: dummy_pathname, contents: closed_practice_row)
              FactoryBot.create(:practice, code: PRACTICE_CODE)

              expect{
                CurrentPracticesCSVFile.new(dummy_pathname).import
              }.to change{ Practice.count }.from(1).to(0)
               .and change{ Practice.deleted.count }.from(0).to(1)
            end
          end
        end
      end
    end
  end
end
