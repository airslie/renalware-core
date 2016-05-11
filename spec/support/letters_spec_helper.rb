module LettersSpecHelper
  def build_letter_to(recipient, *args)
    letter = build(:letter, *args)

    letter.patient.doctor ||= build(:letter_doctor)

    case recipient
    when :patient
      letter.main_recipient = build(:letter_recipient, :main, person_role: "patient")
    when :doctor
      letter.main_recipient = build(:letter_recipient, :main, person_role: "doctor")
    else
      letter.main_recipient = build(:letter_recipient, :main, person_role: "other",
        address: build(:address)
      )
    end
    letter
  end

  def create_letter_to(recipient, *args)
    letter = build_letter_to(recipient, *args)

    case recipient
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

  def create_persisted_letter(recipient, *args)
    letter = build_letter_to(recipient, *args)
    Renalware::Letters::PersistLetter.build.call(letter)
    letter
  end
end