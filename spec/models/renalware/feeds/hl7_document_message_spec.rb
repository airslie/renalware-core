# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Layout/LineLength
module Renalware
  module Feeds
    describe HL7DocumentMessageBuilder do
      include LettersSpecHelper

      before do
        Renalware.configure do |config|
          config.patient_hospital_identifiers = {
            HOSP1: :local_patient_id,
            HOSP2: :local_patient_id_2,
            HOSP3: :local_patient_id_3
          }
        end
      end

      let(:patient) do
        create(
          :letter_patient,
          nhs_number: "9999999999",
          local_patient_id: 111,
          local_patient_id_2: 222,
          local_patient_id_3: 333,
          family_name: "Jones",
          given_name: "Patricia",
          title: "Ms",
          born_on: "01-01-1970",
          sex: "F"
        )
      end

      describe "MSH, PID, TXA, OBX segment" do
        context "when rendering a letter" do
          it do
            stub_const("Renalware::VersionNumber::VERSION", "9.9.9")

            travel_to Time.zone.parse("20211117152417") do
              allow(Renalware::Letters::PdfRenderer).to receive(:call).and_return("A") # base64='QQ==\r'

              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                patient: patient,
                clinical: true,
                author: create(:user, family_name: "Smith", given_name: "Jo")
              )
              msg = described_class.call(renderable: letter, message_id: 123)
              expected_filename = "HOSP1_111_HOSP2_222_HOSP3_333_JONES_19700101_CL_#{letter.id}"

              expect(msg[:MSH].to_s).to eq(
                "MSH|^~\&|Renalware|MSE|||20211117152417||MDM^T02||RW0000000123|U|9.9.9"
              )
              expect(msg[:PID].to_s).to eq(
                "PID||9999999999^^^NHS|111^^^HOSP1~222^^^HOSP2~333^^^HOSP3||Jones^^Patricia^^Ms||19700101|F"
              )
              expect(msg[:TXA].to_s).to eq(
                "TXA||CL^Clinic Letter|ED^Electronic Document|" \
                "#{letter.approved_at.strftime('%Y%m%d%H%M')}|Smith^Jo|" \
                "#{letter.approved_at.strftime('%Y%m%d%H%M')}||||||#{letter.id}||||#{expected_filename}|AU"
              )
              expect(msg[:OBX].to_s).to eq(
                "OBX|1|ED|||^TEXT^PDF^Base64^QQ==\r"
              )
            end
          end

          # context "when the letter has an associated clinic visit" do
          #   it "includes a PV1 segment" do
          #     create(:clinic_visit, patient: patient, datetime: "2021-12-01 09:01:01")
          #     # Letters::Event::ClinicVisit
          #   end
          # end
        end

        context "when rendering an event" do
          it do
            travel_to Time.zone.parse("20211117152417") do
              stub_const("Renalware::VersionNumber::VERSION", "9.9.9")
              allow(Renalware::Events::EventPdf).to receive(:call).and_return("A") # base64='QQ==\r'

              create(
                :swab_event_type,
                external_document_type_code: "XX",
                external_document_type_description: "YY"
              )
              event = Events::EventPdfPresenter.new(
                create(
                  :swab,
                  patient: patient,
                  by: create(:user, family_name: "Smith", given_name: "Jo")
                )
              )
              Renalware.config.ukrdc_site_code = "RJZ"
              create(:hospital_centre, code: "RJZ")

              msg = described_class.call(renderable: event, message_id: 123)

              expected_filename = "HOSP1_111_HOSP2_222_HOSP3_333_JONES_19700101_XX_#{event.id}"

              expect(msg[:MSH].to_s).to eq(
                "MSH|^~\&|Renalware|MSE|||20211117152417||MDM^T02||RW0000000123|U|9.9.9"
              )
              expect(msg[:PID].to_s).to eq(
                "PID||9999999999^^^NHS|111^^^HOSP1~222^^^HOSP2~333^^^HOSP3||Jones^^Patricia^^Ms||19700101|F"
              )
              expect(msg[:TXA].to_s).to eq(
                "TXA||XX^YY|ED^Electronic Document|" \
                "#{event.approved_at.strftime('%Y%m%d%H%M')}|Smith^Jo|" \
                "#{event.approved_at.strftime('%Y%m%d%H%M')}||||||#{event.id}||||#{expected_filename}|AU"
              )
              expect(msg[:OBX].to_s).to eq(
                "OBX|1|ED|||^TEXT^PDF^Base64^QQ==\r"
              )
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
