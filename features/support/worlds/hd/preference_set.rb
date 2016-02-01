module World
  module Hd::PreferenceSet
    module Domain
      # @section helpers
      #
      def hd_preference_set_for(patient)
        Renalware::Hd::PreferenceSet.for_patient(patient).first_or_initialize
      end

      # @section set-ups
      #
      def set_up_hd_preferences_for(patient)
        Renalware::Hd::PreferenceSet.create!(
          patient: patient,
          schedule: :mon_wed_fri_am
        )
      end

      # @section commands
      #
      def create_hd_preferences(user: nil, patient:)
        set_up_hd_preferences_for(patient)
      end

      def update_hd_preferences(patient:, user: nil)
        travel_to 1.hour.from_now

        workup = hd_preference_set_for(patient)
        workup.update_attributes!(
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_hd_preferences_to_exist(patient)
        expect(Renalware::Hd::PreferenceSet.for_patient(patient)).to be_present
      end

      def expect_workup_to_be_modified(patient)
        workup = Renalware::Hd::PreferenceSet.for_patient(patient).first
        expect(workup).to be_modified
      end
    end


    module Web
      include Domain

      def create_hd_preferences(user:, patient:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        click_on "Enter preferences"

        select "Mon, Wed, Fri AM", from: "Schedule"

        click_on "Save"
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
