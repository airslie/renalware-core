module Renalware
  class EsrfInfo < ActiveRecord::Base
    belongs_to :patient
    belongs_to :prd_code
  end
end