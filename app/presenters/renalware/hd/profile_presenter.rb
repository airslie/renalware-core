module Renalware
  module HD
    class ProfilePresenter < DumbDelegator
      attr_reader :preference_set
      delegate :dialysis, :anticoagulant, to: :document
      delegate :dialyser, :dialysate_text, :cannulation_type, to: :dialysis, allow_nil: true
      delegate :type, to: :anticoagulant, allow_nil: true, prefix: true
      alias_attribute :dialysate, :dialysate_text

      def initialize(profile, preference_set: nil)
        super(profile)
        @preference_set = preference_set
      end

      def hospital_unit_hint
        if preference_set.hospital_unit.present?
          "Preference: #{@preference_set.hospital_unit}"
        end
      end

      def schedule_hint
        return if preference_set.preferred_schedule.blank?

        "Preference: #{@preference_set.preferred_schedule}"
      end

      def current_schedule
        return if schedule.blank?

        schedule.other? ? other_schedule : schedule.text
      end

      def last_update
        "#{::I18n.l(updated_at)} by #{updated_by}"
      end

      def hd_type
        document.dialysis.hd_type.try(:text)
      end

    end
  end
end
