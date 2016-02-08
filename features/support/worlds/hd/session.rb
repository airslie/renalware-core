module World
  module HD::Session
    module Domain
      # @section helpers
      #
      def hd_session_for(patient)
        Renalware::HD::Session.for_patient(patient).first_or_initialize
      end

      def valid_session_attributes(patient)
        {
          patient: patient,
          hospital_unit: Renalware::Hospitals::Unit.hd_sites.first,
          modality_description: patient.current_modality,
          performed_on: Time.zone.now.to_date,
          start_time: Time.zone.now,
          document: {
          }
        }
      end

      # @section set-ups
      #
      def set_up_hd_session_for(patient, user:)
        Renalware::HD::Session.create!(
          valid_session_attributes(patient).merge(
            signed_on_by: user,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_hd_session(patient:, user:)
        Renalware::HD::Session.create(
          valid_session_attributes(patient).merge(
            signed_on_by: user,
            by: user
          )
        )
      end

      def update_hd_session(patient:, user:)
        travel_to 1.hour.from_now

        profile = hd_session_for(patient)
        profile.update_attributes!(
          updated_at: Time.zone.now,
          end_time: Time.zone.now,
          signed_off_by: user,
          by: user,
          document: {
          }
        )
      end

      # @section expectations
      #
      def expect_hd_session_to_exist(patient)
        expect(Renalware::HD::Session.for_patient(patient)).to be_present
      end

      # def expect_hd_session_to_be_modified(patient)
      #   profile = Renalware::HD::Session.for_patient(patient).first
      #   expect(profile).to be_modified
      # end

      def expect_hd_session_to_be_refused
        expect(Renalware::HD::Session.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_hd_session(user:, patient:, prescriber:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        click_on "Enter profile"

        select "Mon, Wed, Fri AM", from: "Schedule"
        select prescriber.full_name, from: "Prescriber" if prescriber
        select "300", from: "Flow Rate"

        within ".top" do
          click_on "Create"
        end
      end

      def update_hd_session(patient:, user:, prescriber: nil)
        login_as user
        visit patient_hd_dashboard_path(patient)
        click_on "Edit"

        select "Mon, Wed, Fri PM", from: "Schedule"
        select "400", from: "Flow Rate"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
