module Renalware
  class Problem < ActiveRecord::Base

    acts_as_paranoid

    has_paper_trail class_name: 'Renalware::ProblemVersion'

    belongs_to :patient

    def self.reject_if_proc
      Proc.new { |attrs|
        attrs[:description].blank? && attrs[:snomed_description].blank?
      }
    end

    def full_description
      return snomed_description unless description.present?
      return description unless snomed_description.present?
      "#{snomed_description}, #{description}"
    end

    def formatted
      "#{full_description}, #{date}"
    end
  end
end
