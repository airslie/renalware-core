module World
  module Accesses::Assessment
    module Domain
      # @section helpers
      #
      def assessment_for(patient)
        patient = accesses_patient(patient)
        patient.assessments.first_or_initialize
      end

      def valid_access_assessment_attributes
        {
          performed_on: Time.zone.today,
          type: Renalware::Accesses::Type.first,
          side: :left,
          document: {
            results: {
              method: :hand_doppler
            }
          }
        }
      end

      # @section seeding
      #
      def seed_access_assessment_for(patient, user:)
        patient = accesses_patient(patient)
        patient.assessments.create!(
          valid_access_assessment_attributes.merge(
            site: Renalware::Accesses::Site.first,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access_assessment(patient:, user:, site:)
        patient = accesses_patient(patient)
        patient.assessments.create(
          valid_access_assessment_attributes.merge(
            site: site,
            by: user
          )
        )
      end

      def update_access_assessment(patient:, user:)
        travel_to 1.hour.from_now

        assessment = assessment_for(patient)
        assessment.update_attributes!(
          updated_at: Time.zone.now,
          procedure_on: Time.zone.today,
          by: user
        )
      end

      # @section expectations
      #
      def expect_access_assessment_to_exist(patient)
        patient = accesses_patient(patient)
        expect(patient.assessments).to be_present
      end

      def expect_access_assessment_to_be_refused
        expect(Renalware::Accesses::Assessment.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_access_assessment(user:, patient:, site:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_fieldset "Assessment History" do
          click_on "Add an Access Assessment"
        end

        fill_in "Performed", with: I18n.l(Time.zone.today)
        select "Vein loop", from: "Access Type"
        select site, from: "Access Site"
        select "Right", from: "Access Side"

        within ".top" do
          click_on "Create"
        end
      end

      def update_access_assessment(patient:, user:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_fieldset "Assessment History" do
         click_on "Edit"
        end

        select "Left", from: "Access Side"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end