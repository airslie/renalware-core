module Renalware
  class Hospital < ActiveRecord::Base
    scope :ordered, -> { order(:name) }
    scope :active, -> { where(active: true) }

    validates :code, presence: true
    validates :name, presence: true

    def to_s
      if location.present?
        "#{name} (#{location})"
      else
        name
      end
    end
  end
end
