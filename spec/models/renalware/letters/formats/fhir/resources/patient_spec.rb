# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    describe Resources::Patient do
      subject(:patient_resource) { described_class.call(arguments) }

      let(:author) { instance_double(Renalware::User, uuid: "999") }
      let(:patient) {
        instance_double(
          Renalware::Patient,
          secure_id_dashed: "111",
          nhs_number: "0123456789",
          local_patient_id: "PID1",
          local_patient_id_2: "PID2",
          local_patient_id_3: "",
          local_patient_id_4: nil,
          given_name: "John",
          family_name: "Doe",
          title: "Mr",
          sex: "M",
          born_on: Date.parse("2001-01-02"),
          current_address: nil,
          telephone1: nil,
          email: nil
        )
      }
      let(:letter) { instance_double(Letter, patient: patient, author: author) }
      let(:arguments) do
        Arguments.new(
          transmission: instance_double(Transports::Mesh::Transmission, letter: letter),
          transaction_uuid: "123"
        )
      end

      describe "#fullUrl" do
        subject { patient_resource[:fullUrl] }

        it { is_expected.to eq("urn:uuid:111") }
      end

      describe "#resource" do
        subject(:resource) { patient_resource[:resource] }

        it { expect(resource.id).to eq("111") }

        describe "identifiers" do
          subject(:identifiers) { resource.identifier }

          it { is_expected.to be_a(Array) }

          it "#nhs_number" do
            expect(identifiers[0].system).to eq("https://fhir.nhs.uk/Id/nhs-number")
            expect(identifiers[0].value).to eq("0123456789")
          end

          it "hospital numbers if present" do
            expect(identifiers[1].system).to eq("https://fhir.nhs.uk/Id/local-patient-identifier")
            expect(identifiers[1].value).to eq("PID1")
            expect(identifiers[2].system).to eq("https://fhir.nhs.uk/Id/local-patient-identifier")
            expect(identifiers[2].value).to eq("PID2")
          end
        end

        describe "name" do
          subject(:name) { resource.name }

          it { is_expected.to be_a(Array) }

          it do
            expect(name.length).to eq(1)
            expect(name[0].use).to eq("official")
            expect(name[0].family).to eq("Doe")
            expect(name[0].given[0]).to eq("John")
            expect(name[0].prefix[0]).to eq("Mr")
          end
        end

        describe "#gender" do
          {
            "M" => "male",
            "F" => "female",
            "O" => "other",
            "NK" => "unknown",
            "U" => "unknown",
            "NS" => "unknown",
            "BLABLA" => "unknown"
          }.each do |rw_gender, fhir_gender|
            it "maps patient.sex '#{rw_gender}' to fhir '#{fhir_gender}'" do
              allow(patient).to receive(:sex).and_return(rw_gender)
              expect(resource.gender).to eq(fhir_gender)
            end
          end
        end

        it "birthDate" do
          allow(patient).to receive(:born_on).and_return(Date.parse("2001-01-02"))

          expect(resource.birthDate).to eq("2001-01-02")
        end

        describe "#telecom" do
          subject(:telecom) { resource.telecom }

          it { is_expected.to be_a(Array) }

          it "is an empty array when patient has neither telephone or email" do
            allow(patient).to receive_messages(telephone1: "", email: nil)

            expect(telecom).to eq([])
          end

          it "telephone" do
            allow(patient).to receive(:telephone1).and_return("01234 567890")

            expect(telecom[0].system).to eq("phone")
            expect(telecom[0].value).to eq("01234 567890")
            expect(telecom[0].use).to eq("home")
          end

          it "email" do
            allow(patient).to receive(:email).and_return("john@doe.com")

            expect(telecom[0].system).to eq("email")
            expect(telecom[0].value).to eq("john@doe.com")
          end
        end

        describe "#address" do
          subject(:address) { resource.address }

          it { is_expected.to be_a(Array) }

          it do
            allow(patient).to receive(:current_address).and_return(
              instance_double(
                Renalware::Address,
                street_1: "Address line 1",
                street_2: "Address line 2",
                street_3: "",
                town: "My town",
                county: "My county",
                postcode: "My postcode"
              )
            )

            expect(address[0].line[0]).to eq("Address line 1")
            expect(address[0].line[1]).to eq("Address line 2")
            expect(address[0].line[2]).to eq("My town")
            expect(address[0].line[3]).to eq("My county")
            expect(address[0].postalCode).to eq("My postcode")
          end
        end
      end
    end
  end
end
