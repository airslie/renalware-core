# frozen_string_literal: true

require "success"
require "failure"

require_dependency "renalware/api"

module Renalware
  module API
    module V1
      module HD
        class SessionsController < TokenAuthenticatedAPIController
          # JSON PUT
          # FHIR HD Session resource session data from eg HD Hub (dialyser aggregation).
          # The session may be ongoing or finished.
          # The url for this route specifies sessions/:mrn/:date where
          #   - mrn is the patient
          #   - date is the date the session was started
          # These params allow us to find or create a session unique to this patient and date (a
          # patient cannot have > 1 session in the same day therefore).
          # Is there is already a session with the specified date and patient we load this.
          # We use a form object to parse and validate the JSON.
          # If the session existed we update it, otherwise we create one.
          #
          # Outstanding issues:
          # - if 2 patients have same mrn (eg on in local_patient_id and one in local_patient_id_2)
          #   we could add the sessin to the wrong patient. We don't have DOB in the JSON so can't
          #   use that. We should know the hospital unit - could use that perhaps?
          def update
            form = build_form_object_from_incoming_session_json

            if form.invalid?
              render(status: :bad_request, json: { error: form.errors.full_messages })
            else
              result = create_or_update_hd_session(form)
              status = result.success? ? :ok : :bad_request
              render(status: status, json: result.object)
            end
          end

          private

          def build_form_object_from_incoming_session_json
            Form.new(session_attributes.to_h.symbolize_keys.merge(patient: patient))
          end

          def create_or_update_hd_session(form)
            if hd_session.present?
              UpdateSession.new(hd_session: hd_session, form: form).call
            else
              CreateSession.new(form: form, patient: patient).call
            end
          end

          def patient
            @patient ||= begin
              mrn = params[:mrn]
              sql = <<-SQL.squish
                local_patient_id = ? or
                local_patient_id_2 = ? or
                local_patient_id_3 = ? or
                local_patient_id_4 = ?
              SQL
              Renalware::HD::Patient.where(sql, mrn, mrn, mrn, mrn).first
            end
          end

          def hd_session
            return if patient.blank?

            @hd_session ||= patient.hd_sessions.find_by(performed_on: params[:date])
          end

          class Result
            rattr_initialize [session_id: nil, errors: []]
          end

          class UpdateSession
            pattr_initialize [:hd_session!, :form!]

            def call
              user = Renalware::User.first
              hd_session.update!(
                start_time: form.started_at.strftime("%H:%M"),
                by: user
              )
              ::Success.new(Result.new(session_id: hd_session.id))
            end
          end

          class CreateSession
            pattr_initialize [:form!, :patient!]

            def call
              user = Renalware::User.first
              session = Renalware::HD::Session::Open.new(
                patient: patient,
                hospital_unit: form.hospital_unit,
                performed_on: form.started_at.to_date,
                start_time: form.started_at.strftime("%H:%M"),
                signed_on_by: user,
                by: user
              )
              session.save!
              ::Success.new(Result.new(session_id: session.id))
            end
          end

          class Form
            include ActiveModel::Model
            include ActiveModel::Attributes
            MAX_SESSION_LENGTH = 10.hours

            # These are the attributes we can accept in the ctor/params
            # Some will map directly onto an HD::Session, some will require massaging
            attribute :provider_name, :string
            attribute :mrn, :string
            attribute :started_at, :datetime
            attribute :ended_at, :datetime
            attribute :machine_number, :string
            attribute :machine_ip_address, :string
            attribute :hospital_unit_code, :string
            attribute :state, :string
            attribute :patient

            validates :machine_number, presence: true
            validates :provider_name, presence: true # the param
            validates :provider, presence: { message: "not found" } # the finder
            validates :mrn, presence: true # param
            validates :patient, presence: { message: "not found" } # the finder
            validates :hospital_unit_code, presence: true # the parma
            validates :hospital_unit, presence: { message: "not found" } # the finder
            validates :started_at, presence: true, timeliness: { type: :datetime }
            validates :ended_at,
                      timeliness: {
                        type: :datetime,
                        after: :started_at,
                        before: ->(sess) { sess.started_at + MAX_SESSION_LENGTH }
                      }

            # # Return attributes in a way that can be assigned to an HD::Session?
            # def to_h
            #   hash = attributes.with_indifferent_access
            #   # ignore these attributes
            #   hash = hash.slice!(:provider_name, :mrn, :hospital_unit_code)
            #   # add these derived attributes
            #   hash.merge!(
            #     provider: provider,
            #     patient: patient,
            #     hospital_unit: hospital_unit
            #   )
            #   hash
            # end

            def provider
              @provider ||= Renalware::HD::Provider.where(
                "lower(name) = ?", provider_name&.downcase
              ).first
            end

            def hospital_unit
              @hospital_unit ||= Hospitals::Unit.where(
                "lower(unit_code) = ?", hospital_unit_code&.downcase
              ).first
            end
          end

          def session_attributes
            params.require(:session).permit!
          end
        end
      end
    end
  end
end
