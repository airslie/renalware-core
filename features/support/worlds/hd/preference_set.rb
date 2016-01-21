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
      def set_up_hd_preferences_for(patient)
        Renalware::HD::PreferenceSet.create!(
          patient: patient
        )
      end

      # @section commands
      #
      def create_hd_preferences(user: nil, patient:)
        set_up_hd_preferences_for(patient)
      end

      def update_workup(patient:, user: nil)
        travel_to 1.hour.from_now

        workup = hd_preference_set_for(patient)
        workup.update_attributes!(
          document: {
            historicals: {
              tb: "no"
            }
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_hd_preferences_to_exist(patient)
        expect(Renalware::HD::PreferenceSet.for_patient(patient)).to be_present
      end

      def expect_workup_to_be_modified(patient)
        workup = Renalware::HD::PreferenceSet.for_patient(patient).first
        expect(workup).to be_modified
      end
    end


    module Web
      include Domain

      def create_hd_preferences(user:, patient:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        click_on "Enter workup"

        fill_in "Karnofsky Score", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def update_workup(patient:, user:)
        login_as user
        visit patient_transplants_hd_preferences_path(patient)
        click_on "Edit"

        fill_in "Cervical smear result", with: "193"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
