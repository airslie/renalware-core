module LetterType
  extend ActiveSupport::Concern

  def self.all
    @types ||= %w(ClinicLetter CorrectionLetter DeathNotification DischargeSummary SimpleLetter)
  end

  included do
    class_eval do
      # Create instance methods from letter types eg. 'clinic_letter?', 'death_notification?'
      LetterType.all.each do |t|
        define_method(:"#{t.underscore.to_sym}?") { type == t }
      end
    end
  end
end
