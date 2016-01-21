module Renalware
  class Hospital < ActiveRecord::Base
    has_many :units, class_name: "HospitalUnit"

    scope :ordered, -> { order(:name) }
    scope :active, -> { where(active: true) }
    scope :performing_transplant, -> { active.where(is_transplant_site: true) }

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
