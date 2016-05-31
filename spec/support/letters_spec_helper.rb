module LettersSpecHelper
  def build_letter(to:, patient:, **args)
    letter = build(:draft_letter, **args)
    letter.patient = patient

    letter.patient.doctor ||= build(:letter_doctor)

    attributes = build_main_recipient_attributes(to)
    letter.main_recipient = build(:letter_recipient, :main, attributes)

    letter
  end

  def build_main_recipient_attributes(to)
    case to
    when :patient
      { person_role: "patient" }
    when :doctor
      { person_role: "doctor" }
    else
      { person_role: "other", address: build(:address) }
    end
  end
end
