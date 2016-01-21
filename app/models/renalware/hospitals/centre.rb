require_dependency 'renalware/hospitals'

module Renalware
  module Hospitals
    class Centre < ActiveRecord::Base
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
end