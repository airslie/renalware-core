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

  def create_letter(to:, **args)
    letter = build_letter(to: to, **args)

    case to
    when :patient
      letter.cc_recipients = [build(:letter_recipient, :cc, person_role: "doctor")]
    when :doctor
      letter.cc_recipients = [build(:letter_recipient, :cc, person_role: "patient")]
    else
      letter.cc_recipients = [
        build(:letter_recipient, :cc, person_role: "doctor"),
        build(:letter_recipient, :cc, person_role: "patient")
      ]
    end

    letter.save!

    if letter.state.archived?
      letter.recipients.each do |r|
        r.create_address attributes_for(:address)
      end
    end

    letter
  end
end