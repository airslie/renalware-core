require_dependency "renalware/hospitals"

module Renalware
  module Hospitals
    class Centre < ActiveRecord::Base
      has_many :units, class_name: "Hospitals::Unit", foreign_key: :hospital_centre_id

      scope :ordered, -> { order(:name) }
      scope :active, -> { where(active: true) }
      scope :performing_transplant, -> { active.where(is_transplant_site: true) }
      scope :with_hd_sites, -> { where(id: Unit.hd_sites.pluck(:hospital_centre_id)) }

      validates :code, presence: true
      validates :name, presence: true

      def hd_sites
        units.hd_sites.ordered
      end

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