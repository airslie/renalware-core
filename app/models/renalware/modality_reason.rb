module Renalware
  class ModalityReason < ActiveRecord::Base
    has_many :modalities
  end
end