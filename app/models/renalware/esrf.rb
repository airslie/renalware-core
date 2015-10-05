module Renalware
  class ESRF < ActiveRecord::Base
    self.table_name = "esrf"

    belongs_to :patient
    belongs_to :prd_code

    def to_s
      [diagnosed_on, prd_code].compact.join(" ")
    end
  end
end
