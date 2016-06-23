module World
  module HD::PreferenceSet
    module Domain
      # @section helpers
      #
      def hd_preference_set_for(patient)
        Renalware::HD::PreferenceSet.for_patient(patient).first_or_initialize
      end

      # @section set-ups
      #
      def seed_hd_preferences_for(patient, user:)
        Renalware::HD::PreferenceSet.create!(
          patient: patient,
          schedule: :mon_wed_fri_am,
          by: user
        )
      end

      # @section commands
      #
      def create_hd_preferences(user:, patient:)
        seed_hd_preferences_for(patient, user: user)
      end

      def update_hd_preferences(patient:, user: nil)
        travel_to 1.hour.from_now

        set = hd_preference_set_for(patient)
        set.update_attributes!(
          schedule: :mon_wed_fri_pm,
          updated_at: Time.zone.now,
          by: user
        )
      end

      # @section expectations
      #
      def expect_hd_preferences_to_exist(patient)
        expect(Renalware::HD::PreferenceSet.for_patient(patient)).to be_present
      end
    end


    module Web
      include Domain

      def create_hd_preferences(user:, patient:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        click_on "Enter preferences"

        select "Mon, Wed, Fri AM", from: "Schedule"

        click_on "Create"
      end

      def update_hd_preferences(patient:, user:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        click_on "Edit"

        select "Mon, Wed, Fri PM", from: "Schedule"

        click_on "Save"
      end
    end
  end
end
