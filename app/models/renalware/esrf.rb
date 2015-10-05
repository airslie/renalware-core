module Renalware
  class ESRF < ActiveRecord::Base
    self.table_name = "esrf"

    belongs_to :patient
    belongs_to :prd_code
  end
end
