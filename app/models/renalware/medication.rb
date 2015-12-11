module Renalware
  class Medication < ActiveRecord::Base
    attr_accessor :drug_select

    acts_as_paranoid

    has_paper_trail class_name: 'Renalware::MedicationVersion'

    belongs_to :patient
    belongs_to :medicatable, polymorphic: true
    belongs_to :treatable, polymorphic: true
    belongs_to :medication_route

    validates :patient, presence: true

    validates :medicatable_id, presence: true
    validates :dose, presence: true
    validates :medication_route_id, presence: true
    validates :frequency, presence: true
    validates :start_date, presence: true
    validates :provider, presence: true

    enum provider: %i(gp hospital home_delivery)

    def formatted
      [].tap { |ary|
        ary << medicatable.name if medicatable.present?
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
