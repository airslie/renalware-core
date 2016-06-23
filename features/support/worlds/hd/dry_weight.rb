module World
  module HD::DryWeight
    module Domain
      # @section helpers
      #
      def hd_dry_weight_for(patient)
        Renalware::HD::DryWeight.for_patient(patient).first_or_initialize
      end

      def valid_dry_weight_attributes
        {
          weight: 90,
          assessed_on: Time.zone.today
        }
      end

      # @section seeding
      #
      def seed_hd_dry_weight_for(patient, assessor)
        Renalware::HD::DryWeight.create!(
          valid_dry_weight_attributes.merge(
            patient: patient,
            assessor: assessor,
            by: assessor
          )
        )
      end

      # @section commands
      #
      def create_hd_dry_weight(user: nil, patient:, assessed_on:)
        Renalware::HD::DryWeight.create(
          valid_dry_weight_attributes.merge(
            patient: patient,
            assessor: user,
            assessed_on: assessed_on,
            by: user
          )
        )
      end

      def update_hd_dry_weight(patient:, user:)
        travel_to 1.hour.from_now

        profile = hd_dry_weight_for(patient)
        profile.update_attributes!(
          updated_at: Time.zone.now,
          by: user,
        )
      end

      # @section expectations
      #
      def expect_hd_dry_weight_to_exist(patient)
        expect(Renalware::HD::DryWeight.for_patient(patient)).to be_present
      end

      def expect_hd_dry_weight_to_be_modified(patient)
        profile = Renalware::HD::DryWeight.for_patient(patient).first
        expect(profile).to be_modified
      end

      def expect_hd_dry_weight_to_be_refused
        expect(Renalware::HD::DryWeight.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_hd_dry_weight(user:, patient:, assessed_on:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        click_on "Add a dry weight"

        fill_in "Dry Weight", with: 98
        fill_in "Assessment Date", with: assessed_on

        within ".top" do
          click_on "Create"
        end
      end

      def update_hd_dry_weight(patient:, user:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        click_on "Edit"

        fill_in "Dry Weight", with: 95

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
