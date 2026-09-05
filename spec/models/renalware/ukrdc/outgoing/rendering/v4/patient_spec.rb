module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::Patient do
        include XmlSpecHelper

        def render_xml(patient)
          format_xml(described_class.new(patient:).xml)
        end

        it "assigns the patient a renal_registry_id if the don't have one" do
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, renal_registry_id: nil)
          )

          expect(patient.renal_registry_id).to be_nil
          described_class.new(patient:).xml
          expect(patient.reload.renal_registry_id).not_to be_nil
        end

        it "the patient already has a renal_registry_id it does not change it" do
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, renal_registry_id: "123")
          )

          expect(patient.renal_registry_id).to be_present
          described_class.new(patient:).xml
          expect(patient.reload.renal_registry_id).to eq("123")
        end

        it "includes the prefixed renal registry id as a UKRR_UID national identifier" do
          allow(Renalware.config).to receive(:ukrdc_sending_facility_name).and_return("RAJ")
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, renal_registry_id: "ABC123", sent_to_ukrdc_at: 1.year.ago)
          )

          xml = render_xml(patient)

          expect(xml).to include("<PatientNumbers>")
          expect(xml).to include("<Number>RAJ_ABC123</Number>")
          expect(xml).to include("<Organization>UKRR_UID</Organization>")
          expect(xml).to include("<NumberType>NI</NumberType>")
        end

        it "includes the correctly formatted NHS number" do
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, nhs_number: "6433678181", sent_to_ukrdc_at: 1.year.ago)
          )

          xml = render_xml(patient)

          expect(xml).to include("<PatientNumbers>")
          expect(xml).to include("<Number>6433678181</Number>")
          expect(xml).to include("<Organization>NHS</Organization>")
          expect(xml).to include("<NumberType>NI</NumberType>")
        end

        it "outputs PrimaryLanguage" do
          language = create(:language, :english)
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(
              :patient,
              sent_to_ukrdc_at: 1.year.ago,
              language:
            )
          )

          xml = render_xml(patient)

          expect(xml).to include("<PrimaryLanguage>")
          expect(xml)
            .to include("<CodingStandard>NHS_DATA_DICTIONARY_LANGUAGE_CODE</CodingStandard>")
          expect(xml).to include("<Code>en</Code>")
        end

        it "uses the base Treatment renderer when a treatment has no modality description" do
          patient = instance_double(Renalware::UKRDC::PatientPresenter)

          renderer = described_class.new(patient:)

          expect(renderer.send(:treatment_class_for, nil)).to eq(Rendering::V4::Treatment)
        end

        context "when the language is Other (ot)" do
          it "does not output it" do
            language = create(:language, :other)
            patient = Renalware::UKRDC::PatientPresenter.new(
              create(
                :patient,
                sent_to_ukrdc_at: 1.year.ago,
                language:
              )
            )

            xml = render_xml(patient)

            expect(xml).not_to include("<PrimaryLanguage>")
          end
        end

        context "when the patient has requested UKRDC anonymisation" do
          let(:xml) { render_xml(patient) }
          let(:patient) do
            allow(Renalware.config).to receive(:ukrdc_sending_facility_name).and_return("RAJ")
            practice = create(:practice, code: "A12345")
            gp = create(:primary_care_physician, code: "G1111111")
            address = build(
              :address,
              street_1: "1 Test Street",
              street_2: "Test Road",
              street_3: "Test Village",
              town: "Test Town",
              county: "Test County",
              postcode: "BS10 5NB"
            )
            Renalware::UKRDC::PatientPresenter.new(
              create(
                :patient,
                current_address: address,
                family_name: "Jones",
                given_name: "Jack",
                born_on: "1988-06-05",
                nhs_number: "6433678181",
                local_patient_id: "HOSP123",
                practice:,
                primary_care_physician: gp,
                renal_registry_id: "ABC123",
                sent_to_ukrdc_at: 1.year.ago,
                ukrdc_anonymise: true,
                ukrdc_anonymise_decision_on: nil,
                ukrdc_external_id: "external-123"
              )
            )
          end

          it "sends anonymised replacement values and a local UKRR OptOut" do
            expect(xml).to include("<Family>CONSENT</Family>")
            expect(xml).to include("<Given>REFUSED</Given>")
            expect(xml).to include("<BirthTime>1988-01-01T00:00:00+00:00</BirthTime>")
            expect(xml).to include("<Number>RAJ_ABC123</Number>")
            expect(xml).to include("<Organization>UKRR_UID</Organization>")
            expect(xml).to include("<NumberType>NI</NumberType>")
            expect(xml).to include("<NumberType>MRN</NumberType>")
            expect(xml).to include("<Postcode>BS10</Postcode>")
            expect(xml).to include("<ProgramName>UKRR</ProgramName>")
            expect(xml).to include("<FromTime>1900-01-01</FromTime>")
          end

          it "does not send directly identifying patient values" do
            expect(xml).not_to include("Jones")
            expect(xml).not_to include("Jack")
            expect(xml).not_to include("6433678181")
            expect(xml).not_to include("HOSP123")
            expect(xml).not_to include("1 Test Street")
            expect(xml).not_to include("Test Town")
            expect(xml).not_to include("Test County")
            expect(xml).not_to include("A12345")
            expect(xml).not_to include("G1111111")
            expect(xml).not_to include("external-123")
          end

          it "does not send documents" do
            expect(xml).not_to include("<Documents>")
          end

          it "generates valid V4 XML" do
            schema = Renalware::UKRDC::XsdSchema.new(major_version: 4)

            expect(schema.validate(xml)).to be_empty
          end
        end
      end
    end
  end
end
