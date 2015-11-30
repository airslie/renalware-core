module Renalware
  class ESRF < ActiveRecord::Base
    self.table_name = "esrf"

    belongs_to :patient
    belongs_to :prd_description

    validates :diagnosed_on, presence: true

    validates :diagnosed_on, timeliness: { type: :date }

    def to_s
      [I18n.l(diagnosed_on), prd_description].compact.join(" ")
    end
  end
end
