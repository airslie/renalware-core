module Renalware
  module HD
    class SessionPresenter < SimpleDelegator
      attr_reader :preference_set
      delegate :info,
               :observations_before,
               :observations_after,
               :dialysis,
               to: :document, allow_nil: true
      delegate :access_type,
               :access_type_abbreviation,
               :access_site,
               :access_side,
               :machine_no,
               to: :info, allow_nil: true
      delegate :arterial_pressure,
               :venous_pressure,
               :blood_flow,
               :fluid_removed,
               :litres_processed,
               :machine_urr,
               :machine_ktv,
               to: :dialysis, allow_nil: true
      delegate :unit_code,
               to: :hospital_unit,
               prefix: true, allow_nil: true

      def state
        self.class.to_s.demodulize.downcase
      end

      def class
        __getobj__.class
      end

      def initialize(session, view_context = nil)
        @view_context = view_context
        @session = session
        super(session)
      end

      def performed_on
        url = view_context.patient_hd_session_path(session.patient, session)
        text = ::I18n.l(super)
        view_context.link_to(text, url)
      end

      def start_time
        ::I18n.l(super, format: :time)
      end

      def end_time
        ::I18n.l(super, format: :time)
      end

      def duration
        super && ::Renalware::Duration.from_minutes(super)
      end

      def before_measurement_for(measurement)
        observations_before.try(measurement.to_sym)
      end

      def after_measurement_for(measurement)
        observations_after.try!(measurement.to_sym)
      end

      def change_in(measurement)
        pre = before_measurement_for(measurement)
        post = after_measurement_for(measurement)
        return if pre.blank? || post.blank?
        case pre
        when ::Float ; (post - pre).round(1)
        when ::Fixnum ;(post - pre)
        else raise "Unsupported class '#{pre.class}'' - cannot calculate the change"
        end
      end

      def summarised_access_used
        Renalware::HD::SessionAccessPresenter.new(self).to_html
      end

      def access_used
        Renalware::HD::SessionAccessPresenter.new(self).to_s
      end

      def truncated_notes
        return unless notes
        notes.truncate(100, omission: "&hellip;").html_safe
      end

      def edit_or_view_url
        i18n_scope = "renalware.hd.sessions.#{session.state}"
        if immutable?
          view_context.link_to(I18n.t(".view", scope: i18n_scope),
                               view_context.patient_hd_session_path(patient, self),
                               class: "nowrap")
        else
          view_context.link_to(I18n.t(".edit", scope: i18n_scope),
                               view_context.edit_patient_hd_session_path(patient, self),
                               class: "nowrap")
        end

      end

      protected
      attr_reader :session, :view_context
    end
  end
end
