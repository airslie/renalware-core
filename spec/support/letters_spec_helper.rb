module LettersSpecHelper
  def build_letter_to(recipient, *args)
    letter = build(:letter, *args)

    case recipient
    when :patient
      letter.main_recipient = build(:letter_main_recipient, source_type: "Renalware::Patient")
    when :doctor
      letter.main_recipient = build(:letter_main_recipient, source_type: "Renalware::Doctor")
    else
      letter.main_recipient = build(:letter_main_recipient, source: nil,
        name: "John Doe", address: build(:address)
      )
    end
    letter
  end

  def create_letter_to(recipient, *args)
    letter = build_letter_to(recipient, *args)

    case recipient
    when :patient
      letter.cc_recipients = [build(:letter_cc_recipient, source: letter.patient.doctor)]
    when :doctor
      letter.cc_recipients = [build(:letter_cc_recipient, source: letter.patient)]
    else
      letter.cc_recipients = [
        build(:letter_cc_recipient, source: letter.patient.doctor),
        build(:letter_cc_recipient, source: letter.patient)
      ]
    end

    letter.save!
    letter
  end

  def create_persisted_letter(recipient, *args)
    letter = build_letter_to(recipient, *args)
    Renalware::Letters::PersistLetter.build.call(letter)
    letter
  end
end