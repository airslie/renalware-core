require_dependency "renalware"

module Renalware
  module HD
    module HasSchedule
      extend ActiveSupport::Concern

      included do
        extend Enumerize

        enumerize :schedule,
          in: I18n.t(:schedule, scope: "enumerize.#{model_name.i18n_key}", cascade: true).keys

        validates :other_schedule, presence: true, if: :other_schedule_required?
      end

      private

      def other_schedule_required?
        schedule.try(:text) =~ /specify/
      end
    end
  end
end