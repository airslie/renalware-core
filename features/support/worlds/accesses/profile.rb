module World
  module Accesses::Profile
    module Domain
      # @section helpers
      #
      def profile_for(patient)
        Renalware::Accesses::Profile.for_patient(patient).first_or_initialize
      end

      def valid_access_profile_attributes(patient)
        {
          patient: patient,
          formed_on: Time.zone.today,
          type: Renalware::Accesses::Type.first,
          side: :left
        }
      end

      # @section set-ups
      #
      def set_up_access_profile_for(patient, user:)
        Renalware::Accesses::Profile.create!(
          valid_access_profile_attributes(patient).merge(
            site: Renalware::Accesses::Site.first,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access_profile(patient:, user:, site:)
        Renalware::Accesses::Profile.create(
          valid_access_profile_attributes(patient).merge(
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
        expect(Renalware::Accesses::Profile.for_patient(patient)).to be_present
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
