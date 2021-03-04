# frozen_string_literal: true

require "success"
require "failure"

# class OpenStruct
#   def to_json
#     to_hash.to_json
#   end

#   def to_hash
#     to_h.map { |k, v|
#       v.respond_to?(:to_hash) ? [k, v.to_hash] : [k, v]
#     }.to_h
#   end
# end

require_dependency "renalware/api"

module Renalware
  module API
    module V1
      module HD
        class SessionsController < TokenAuthenticatedAPIController
          # Authentication already done courtesy of TokenAuthenticatedAPIController
          # 1. Validate json
          # 2. Find existing session using params[:uuid]
          # 3. Update if present else create
          # 4. return ... what?
          def update
            form = Form.new(session_attributes.to_h.symbolize_keys.merge(patient: patient))

            if form.invalid?
              render(status: :bad_request, json: { error: form.errors.full_messages })
            else

              result = if hd_session.present?
                         UpdateSession.new(hd_session: hd_session, form: form).call
                       else
                         CreateSession.new(form).call
                       end
              status = result.success? ? :ok : :bad_request
              render(status: status, json: result.object)
            end
          end

          private

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

          class UpdateSession
            pattr_initialize [:hd_session!, :form!]

            class Result
              rattr_initialize [session_id: nil, errors: []]
            end

            def call
              ::Success.new(Result.new(session_id: hd_session.id))
            end
          end

          class CreateSession
            pattr_initialize :form

            class Result
              rattr_initialize [session_id: nil, errors: []]
            end

            def call
              ::Success.new(Result.new(session_id: nil))
            end
          end

          # Find and update or create a new session
          # Return the session created successfully, or if found
          # Return appropriate errors if could not save
          # class CreateOrUpdateSession
          #   class Result
          #     rattr_initialize [session_id: nil, errors: []]
          #   end

          #   def call
          #     # Renalware::HD::Session.create(options)
          #     ::Success.new(Result.new(session_id: 123))
          #     # or ::Failure.new({ errors: ["some error" })
          #   end
          # end

          class SessionBuilder
            pattr_initialize :form

            # Return a new
            def call
              # noop
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
                      presence: true,
                      timeliness: {
                        type: :datetime,
                        on_or_after: ->(sess) { sess.started_at },
                        before: ->(sess) { sess.started_at + MAX_SESSION_LENGTH }
                      }

            # Return attributes in a way that can be assigned to an HD::Session?
            def to_h
              hash = attributes.with_indifferent_access
              # ignore these attributes
              hash = hash.slice!(:provider_name, :mrn, :hospital_unit_code)
              # add these derived attributes
              hash.merge!(
                provider: provider,
                patient: patient,
                hospital_unit: hospital_unit
              )
              hash
            end

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
