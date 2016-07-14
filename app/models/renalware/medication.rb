module Renalware
  class Medication < ActiveRecord::Base
    include Accountable

    attr_accessor :drug_select

    has_paper_trail class_name: 'Renalware::MedicationVersion'

    belongs_to :patient
    belongs_to :drug, class_name: "Renalware::Drugs::Drug"
    belongs_to :treatable, polymorphic: true
    belongs_to :medication_route

    validates :patient, presence: true
    validates :treatable, presence: true
    validates :drug, presence: true
    validates :dose, presence: true
    validates :medication_route, presence: true
    validates :frequency, presence: true
    validates :prescribed_on, presence: true
    validates :provider, presence: true
    validate :constrain_route_description

    enum provider: Provider.codes

    scope :ordered, -> { order(default_search_order) }
    scope :current, -> { where(terminated_on: nil) }
    scope :terminated, -> { where("terminated_on IS NOT NULL") }

    def self.default_search_order
      "prescribed_on desc"
    end

    def self.peritonitis
      self.new(treatable_type: 'Renalware::PeritonitisEpisode')
    end

    def self.exit_site
      self.new(treatable_type: 'Renalware::ExitSiteInfection')
    end

    def terminate(by:)
      self.by = by
      self.terminated_on = Date.current
      self
    end

    def current?
      self.terminated_on.nil?
    end

    def terminated?
      self.terminated_on.present?
    end

    private

    def constrain_route_description
      return unless medication_route

      case
      when medication_route.other? && !route_description.present?
        errors.add(:route_description, :blank)
      when !medication_route.other? && route_description.present?
        errors.add(:route_description, :not_other)
      end
    end
  end
end
