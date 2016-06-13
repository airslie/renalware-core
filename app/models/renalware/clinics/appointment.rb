module Renalware
  module Clinics
    class Appointment < ActiveRecord::Base
      belongs_to :patient
      belongs_to :clinic
      belongs_to :user

      validates_presence_of :starts_at
      validates_presence_of :patient
      validates_presence_of :clinic
      validates_presence_of :user

      validates :starts_at, timeliness: { type: :datetime }

      def date
        starts_at.strftime(I18n.t("date.formats.default"))
      end

      def time
        starts_at.strftime("%H:%M")
      end
    end
  end
end
