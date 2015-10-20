module Renalware
  class ESRF < ActiveRecord::Base
    self.table_name = "esrf"

    belongs_to :patient
    belongs_to :prd_description

    validates :diagnosed_on, presence: true

    def to_s
      [diagnosed_on, prd_description].compact.join(" ")
    end
  end
end
