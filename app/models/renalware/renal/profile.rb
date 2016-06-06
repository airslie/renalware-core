require_dependency "renalware/renal"

module Renalware
  module Renal
    class Profile < ActiveRecord::Base
      belongs_to :patient
      belongs_to :prd_description

      validates :patient, presence: true
      validates :diagnosed_on, presence: true
      validates :diagnosed_on, timeliness: { type: :date }

      def to_s
        [I18n.l(diagnosed_on), prd_description].compact.join(" ")
      end
    end
  end
end
