module LettersSpecHelper
  def build_letter(to:, patient:, **args)
    letter = build(:letter, **args)
    letter.patient = patient

    letter.patient.doctor ||= build(:letter_doctor)

    case to
    when :patient
      attributes = { person_role: "patient" }
    when :doctor
      attributes = { person_role: "doctor" }
    else
      attributes = { person_role: "other", address: build(:address) }
    end
    letter.main_recipient = build(:letter_recipient, :main, attributes)

    letter
  end
end