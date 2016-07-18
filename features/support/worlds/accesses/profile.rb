module World
  module Accesses::Profile
    module Domain
      # @section helpers
      #
      def profile_for(patient)
        patient = accesses_patient(patient)
        patient.profiles.first_or_initialize
      end

      def valid_access_profile_attributes
        {
          formed_on: Time.zone.today,
          type: Renalware::Accesses::Type.first,
          side: :left
        }
      end

      # @section seeding
      #
      def seed_access_profile_for(patient, user:)
        patient = accesses_patient(patient)
        patient.profiles.create!(
          valid_access_profile_attributes.merge(
            site: Renalware::Accesses::Site.first,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access_profile(patient:, user:, site:)
        patient = accesses_patient(patient)
        patient.profiles.create(
          valid_access_profile_attributes.merge(
            site: site,
            by: user
          )
        )
      end

      def update_access_profile(patient:, user:)
        travel_to 1.hour.from_now

        profile = profile_for(patient)
        profile.update_attributes!(
          updated_at: Time.zone.now,
          started_on: Time.zone.today,
          by: user
        )
      end

      # @section expectations
      #
      def expect_access_profile_to_exist(patient)
        patient = accesses_patient(patient)
        expect(patient.profiles).to be_present
      end

      def expect_access_profile_to_be_refused
        expect(Renalware::Accesses::Profile.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_access_profile(user:, patient:, site:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_fieldset "Access Profile History" do
          click_on "Add an Access Profile"
        end

        fill_in "Formed On", with: I18n.l(Time.zone.today)
        select "Vein loop", from: "Access Type"
        select site, from: "Access Site"
        select "Right", from: "Access Side"

        within ".top" do
          click_on "Create"
        end
      end

      def update_access_profile(patient:, user:)
        login_as user
        visit patient_accesses_dashboard_path(patient)
        within_fieldset "Access Profile History" do
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
