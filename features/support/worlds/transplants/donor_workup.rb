module World
  module Transplants::DonorWorkup
    module Domain
      # @section helpers
      #
      def donor_workup_for(patient)
        Renalware::Transplants::DonorWorkup.for_patient(patient).first_or_initialize
      end

      # @section set-ups
      #
      def set_up_doner_workup_for(patient)
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            }
          }
        )
      end

      # @section commands
      #
      def create_donor_workup(user: nil, patient:)
        set_up_doner_workup_for(patient)
      end

      def update_donor_workup(patient:, user: nil)
        travel_to 1.hour.from_now

        workup = donor_workup_for(patient)
        workup.update_attributes!(
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            },
            comorbidities: {
              angina: {
                status: "no"
              }
            }
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_donor_workup_to_exist(donor)
        expect(Renalware::Transplants::DonorWorkup.for_patient(donor)).to be_present
      end

      def expect_donor_workup_to_be_modified(patient)
        workup = Renalware::Transplants::DonorWorkup.for_patient(patient).first
        expect(workup.updated_at).to_not eq(workup.created_at)
      end
    end


    module Web
      include Domain

      def create_donor_workup(user:, patient:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Donor Workup"

        select "Mother or father", from: "Relationship to Recipient"
        fill_in "Oral GTT", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_workup(patient:, user:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Donor Workup"
        click_on "Edit"

        fill_in "Calculated Clearance", with: "193"

        within ".top" do
          click_on "Save"
        end
      end
    end
 end
end