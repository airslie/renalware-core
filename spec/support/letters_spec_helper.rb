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

    # This type hack is to resolve an issue where STI #type not getting set on the letter
    # in certain circumstance. Not great but hopefully the mists will clear and we'll work out why
    # this is and remove this at some point.
    letter.type ||= letter.class.sti_name

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
      address_attributes = attributes_for(:address)
      {
        person_role: "contact",
        address_attributes: address_attributes,
        addressee: build(:directory_person, address_attributes: address_attributes)
      }
    end
  end
end
