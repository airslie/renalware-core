module Renalware
  module Virology
    class HepatitisCDiagnosis < YearDatedDiagnosis
      attribute :ended_on, Date

      validates :ended_on, timeliness: { type: :date, allow_blank: true }
      validate :ended_on_after_beginning_of_confirmed_year

      def to_s
        ended_on_text = "ended #{I18n.l(ended_on)}" if ended_on.present?
        [super.presence, ended_on_text].compact.join(", ")
      end

      private

      def ended_on_after_beginning_of_confirmed_year
        return if ended_on.blank? || confirmed_on_year.blank?
        return if ended_on > Date.new(confirmed_on_year, 1, 1)

        errors.add(:ended_on, "must be after the beginning of the diagnosis year")
      end
    end
  end
end
