module Renalware
  class Hospital < ActiveRecord::Base
    scope :ordered, -> { order(:name) }

    validates :code, presence: true
    validates :name, presence: true
  end
end
