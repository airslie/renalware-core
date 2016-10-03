module LettersSpecHelper
  def build_letter(state: :draft, to:, patient:, **args)
    trait = "#{state}_letter".to_sym
    letter = build(trait, **args)
    letter.patient = patient

    letter.patient.primary_care_physician ||= build(:letter_primary_care_physician)

    attributes = build_main_recipient_attributes(to)
    letter.main_recipient = build(:letter_recipient, :main, attributes)

    letter
  end

  def create_letter(**args)
    letter = build_letter(args)
    letter.save!
    letter
  end

  def build_main_recipient_attributes(to)
    case to
    when :patient
      { person_role: "patient" }
    when :primary_care_physician
      { person_role: "primary_care_physician" }
    else
      { person_role: "contact", address: build(:address) }
    end
  end
end
