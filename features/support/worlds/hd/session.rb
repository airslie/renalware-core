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
          performed_on: Time.zone.today,
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

      def set_up_hd_sessions(table)
        table.hashes.each do |row|
          signed_on_by = find_or_create_user(given_name: row[:signed_on_by], role: "clinician")
          signed_off_by = find_or_create_user(given_name: row[:signed_off_by], role: "clinician")
          patient = create_patient(full_name: row[:patient])

          session = set_up_hd_session_for(patient, user: signed_on_by)
          session.signed_off_by = signed_off_by
          session.save!
        end
      end

      # @section commands
      #
      def create_hd_session(patient:, user:, performed_on:)
        Renalware::HD::Session.create(
          valid_session_attributes(patient).merge(
            performed_on: performed_on,
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
          end_time: profile.start_time + 1.minute,
          signed_off_by: user,
          by: user,
          document: {
          }
        )
      end

      def view_ongoing_hd_sessions(user: nil)
        @query = Renalware::HD::Sessions::OngoingQuery.new()
      end

      # @section expectations
      #
      def expect_hd_session_to_exist(patient)
        expect(Renalware::HD::Session.for_patient(patient)).to be_present
      end

      def expect_hd_session_to_be_refused
        expect(Renalware::HD::Session.count).to eq(0)
      end

      def expect_hd_sessions_to_be(hashes)
        sessions = @query.call
        expect(sessions.size).to eq(hashes.size)

        entries = sessions.map do |session|
          hash = {
            patient: session.patient.to_s,
            signed_on_by: session.signed_on_by.given_name,
            signed_off_by: (session.signed_off_by.try(:given_name) || "")
          }
          hash.with_indifferent_access
        end
        hashes.each do |row|
          expect(entries).to include(row)
        end
      end
    end


    module Web
      include Domain

      def create_hd_session(user:, patient:, performed_on:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        within_fieldset "Latest HD Sessions" do
          click_on "Add a session"
        end

        fill_in "Session Start Time", with: "13:00"
        select hd_unit.to_s, from: "Hospital Unit"
        fill_in "Session Date", with: I18n.l(performed_on)

        within ".top" do
          click_on "Create"
        end
      end

      def update_hd_session(patient:, user:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        within_fieldset "Latest HD Sessions" do
          click_on "Sign Off"
        end

        fill_in "Session End Time", with: "16:00"

        within ".top" do
          click_on "Save"
        end
      end

      def view_ongoing_hd_sessions(user:)
        login_as user
        visit hd_ongoing_sessions_path
      end

      def expect_hd_sessions_to_be(hashes)
        hashes.each do |row|
          expect(page.body).to have_content(row[:patient])
        end
      end
    end
  end
end
