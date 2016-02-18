module World
  module Accesses::Procedure
    module Domain
      # @section helpers
      #
      def procedure_for(patient)
        Renalware::Accesses::Procedure.for_patient(patient).first_or_initialize
      end

      def valid_access_procedure_attributes(patient)
        {
          patient: patient,
          performed_on: Time.zone.today,
          type: Renalware::Accesses::Type.first,
          performed_by: Renalware::User.first,
          side: :left
        }
      end

      # @section set-ups
      #
      def set_up_access_procedure_for(patient, user:)
        Renalware::Accesses::Procedure.create!(
          valid_access_procedure_attributes(patient).merge(
            site: Renalware::Accesses::Site.first,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access_procedure(patient:, user:, site:)
        Renalware::Accesses::Procedure.create(
          valid_access_procedure_attributes(patient).merge(
            site: site,
            by: user
          )
        )
      end

      def update_access_procedure(patient:, user:)
        travel_to 1.hour.from_now

        procedure = procedure_for(patient)
        procedure.update_attributes!(
          updated_at: Time.zone.now,
          first_used_on: Time.zone.today,
          by: user
        )
      end

      # @section expectations
      #
      def expect_access_procedure_to_exist(patient)
        expect(Renalware::Accesses::Procedure.for_patient(patient)).to be_present
      end

      def expect_access_procedure_to_be_refused
        expect(Renalware::Accesses::Procedure.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_access_procedure(user:, patient:, site:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_fieldset "Procedure History" do
          click_on "Add an Access Procedure"
        end

        fill_in "Performed", with: I18n.l(Time.zone.today)
        select user.full_name, from: "Performed By"
        select "Vein loop", from: "Access Type"
        select site, from: "Access Site"
        select "Right", from: "Access Side"

        within ".top" do
          click_on "Create"
        end
      end

      def update_access_procedure(patient:, user:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_fieldset "Procedure History" do
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