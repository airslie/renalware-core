module LettersSpecHelper
  def build_letter(state: :draft, to:, patient:, **args)
    trait = "#{state}_letter".to_sym
    letter = build(trait, **args)
    letter.patient = patient

    letter.patient.primary_care_physician ||= build(:letter_primary_care_physician)

    attributes = build_main_recipient_attributes(to)
    letter.main_recipient = build(:letter_recipient, :main, attributes)

    # We shouldn't have to do this but for some reason in RSpec tests if the second test in a suite
    # creates a letter it can end up with type of nil - something in Rails is not setting it.
    # Hence this unpleasant hack:
    letter.type ||= letter.class.sti_name

    letter
  end

  def create_letter(**args)
    letter = build_letter(args)
    letter.save!
    letter
  end

  # rubocop:disable Metrics/MethodLength
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
  # rubocop:enable Metrics/MethodLength
end
