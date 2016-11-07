module Renalware
  module HD
    module Sessions

      # A generic service object which saves a (new or existing) HD::Session of any (STI) type.
      class SaveSession
        include Wisper::Publisher
        attr_reader :patient, :params, :current_user, :session_type

        def initialize(patient:, current_user:)
          @patient = patient
          @current_user = current_user
        end

        # Note that in the event of a #save failure due to a validation error,
        # we must revert the session's :type to the original
        # in case they want to save the session as another type i.e. they tried to save as
        # Closed (sign-off) but next time they want to save as Open (not signed off)
        # - so we need make sure the hidden :type form value is not rendered as :closed
        # This is getting a bit confusing and might need some refactoring, for example by
        # driving the :type to save as using the button on the form (which we already do using
        # the sign-off name of the SignOff button - see signed_off?
        def call(params:, id: nil, signing_off: false)
          @params = parse_params(params)
          session = find_or_create_session(id)
          session = update_session_attributes(session, signing_off)

          UpdateRollingPatientStatisticsJob.perform_later(patient) unless session.open?
          if session.save
            broadcast(:save_success, session)
          else
            session.type = session_type  # See method comment
            broadcast(:save_failure, session)
          end

        end

        private

        def parse_params(params)
          @session_type = params.delete(:type)
          raise(ArgumentError, "Missing type in session params") unless @session_type.present?
          params
        end

        def update_session_attributes(session, signing_off)
          session = signed_off(session) if signing_off
          session.attributes = params
          session.by = current_user
          lookup_access_type_abbreviation(session)
          session
        end

        def find_or_create_session(id)
          if id.present?
            Session.for_patient(patient).find(id)
          else
            session_klass.new(patient: @patient)
          end
        end

        # NB Will return a different session object
        def signed_off(session)
          session = session.becomes!(Session::Closed)
          session.profile = patient.hd_profile
          session.dry_weight = Renalware::HD::DryWeight.for_patient(patient).first
          session
        end

        def session_klass
          session_type.constantize
        end

        def lookup_access_type_abbreviation(session)
          return unless session.document

          if (access_type = Accesses::Type.find_by(name: session.document.info.access_type))
            session.document.info.access_type_abbreviation = access_type.abbreviation
          end
        end
      end
    end
  end
end
