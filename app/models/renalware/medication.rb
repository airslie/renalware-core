module Renalware
  class Medication < ActiveRecord::Base
    attr_accessor :drug_select

    acts_as_paranoid

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
    validates :start_date, presence: true
    validates :provider, presence: true

    enum provider: Provider.codes

    scope :ordered, -> { order(default_search_order) }

    def self.default_search_order
      "start_date desc"
    end

    def formatted
      [].tap { |ary|
        ary << drug.name if drug.present?
        ary << dose
        ary << medication_route.name if medication_route.present?
        ary << frequency
        ary << start_date
      }.compact.join(', ')
    end

    def self.peritonitis
      self.new(treatable_type: 'Renalware::PeritonitisEpisode')
    end

    def self.exit_site
      self.new(treatable_type: 'Renalware::ExitSiteInfection')
    end

  end
end
