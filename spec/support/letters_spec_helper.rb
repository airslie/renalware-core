module LettersSpecHelper
  def build_letter_to(recipient, *args)
    letter = build(:letter, *args)

    case recipient
    when :patient
      letter.main_recipient = build(:letter_main_recipient, person_role: "patient")
    when :doctor
      letter.main_recipient = build(:letter_main_recipient, person_role: "doctor")
    else
      letter.main_recipient = build(:letter_main_recipient, person_role: "outsider",
        address: build(:address)
      )
    end
    letter
  end

  def create_letter_to(recipient, *args)
    letter = build_letter_to(recipient, *args)

    case recipient
    when :patient
      letter.cc_recipients = [build(:letter_cc_recipient, person_role: "doctor")]
    when :doctor
      letter.cc_recipients = [build(:letter_cc_recipient, person_role: "patient")]
    else
      letter.cc_recipients = [
        build(:letter_cc_recipient, person_role: "doctor"),
        build(:letter_cc_recipient, person_role: "patient")
      ]
    end

    letter.save!

    if letter.state.archived?
      letter.recipients.each do |recipient|
        recipient.create_address attributes_for(:address)
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