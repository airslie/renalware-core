# rubocop:disable Metrics/ModuleLength
require "rails_helper"

module Renalware
  describe Letters::PracticeEmailMetaData do
    include LettersSpecHelper

    let(:user) do
      build_stubbed(
        :user,
        family_name: "Bach",
        given_name: "Johann Sebastian",
        signature: "Johann S. Bach"
      )
    end
    let(:practice) { build(:practice, code: "PRAC1") }
    let(:primary_care_physician) do
      build(:primary_care_physician, code: "G123").tap{ |gp| gp.practices << practice }
    end
    let(:patient) do
      build(
        :letter_patient,
        family_name: "Jones",
        given_name: "Tom",
        local_patient_id: "Z123",
        nhs_number: "0123456789",
        born_on: "01-Feb-1967",
        by: user
      )
    end

    let(:letter) {
      build_letter(
        patient: patient,
        to: primary_care_physician,
        issued_on: "01-Jan-2018",
        author: user,
        by: user
      )
    }

    describe ".to_s which builds an IDENT string describing the letter attachment in the email, "\
             "and which will be parsed at the practice to file the letter appropriately" do
      context "when config defaults are assumed" do
        it "renders the IDENT using defaults for missing arguments" do
          allow(letter).to receive(:id).and_return(111)

          # care_group_name, letter_name and letter_system_name are not supplied so
          # config values will be used
          metadata = described_class.new(
            letter: letter,
            primary_care_physician: primary_care_physician,
            practice: practice
          )

          Renalware.configure do |config|
            config.letter_system_name = "ConfiguredSystem"
            config.letter_default_care_group_name = "ConfiguredCareGroup"
            config.letter_default_letter_name = "ConfiguredLetterName"
            config.hospital_name = "ConfiguredHospitalName"
          end

          expect(metadata.to_s).to eq(
            "<IDENT>"\
            "PRAC1|"\
            "Jones|"\
            "Tom|"\
            "Z123|"\
            "0123456789|"\
            "01/02/1967|"\
            "ConfiguredHospitalName|"\
            "ConfiguredSystem|"\
            "01/01/2018|"\
            "ConfiguredLetterName|"\
            "111|"\
            "Bach, Johann Sebastian|"\
            "01/01/2018|"\
            "G123|"\
            "ConfiguredCareGroup|"\
            "Johann S. Bach"\
            "</IDENT>"
          )
        end
      end

      context "when all arguments are supplied to the initializer" do
        it "these override the defaults" do
          allow(letter).to receive(:id).and_return(111)

          metadata = described_class.new(
            letter: letter,
            primary_care_physician: primary_care_physician,
            practice: practice,
            hospital_name: "MyHospital",
            care_group_name: "MyCareGroup",
            letter_name: "MyLetterName",
            letter_system_name: "MySystem"
          )

          expect(metadata.to_s).to eq(
            "<IDENT>"\
            "PRAC1|"\
            "Jones|"\
            "Tom|"\
            "Z123|"\
            "0123456789|"\
            "01/02/1967|"\
            "MyHospital|"\
            "MySystem|"\
            "01/01/2018|"\
            "MyLetterName|"\
            "111|"\
            "Bach, Johann Sebastian|"\
            "01/01/2018|"\
            "G123|"\
            "MyCareGroup|"\
            "Johann S. Bach"\
            "</IDENT>"
          )
        end
      end
    end
  end
end
