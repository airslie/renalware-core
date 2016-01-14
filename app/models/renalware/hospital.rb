module Renalware
  class Hospital < ActiveRecord::Base
    scope :ordered, -> { order(:name) }
    scope :active, -> { where(active: true) }

    validates :code, presence: true
    validates :name, presence: true
  end
end
