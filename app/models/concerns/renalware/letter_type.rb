module Renalware
  module LetterType
    extend ActiveSupport::Concern

    def self.all
      @types ||= %w(ClinicLetter CorrectionLetter DeathNotification DischargeSummary Letter)
    end

    def self.valid_classes
      @types.map { |t| "Renalware::#{t}" }
    end

    included do
      class_eval do
        # Create instance methods from letter types eg. 'clinic_letter?', 'death_notification?'
        LetterType.all.each do |t|
          define_method(:"#{t.underscore.to_sym}?") { short_type == t }
        end
      end
    end

    def short_type
      model_name.name.gsub(/Renalware::/, '')
    end
  end
end