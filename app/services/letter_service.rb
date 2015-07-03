class LetterService
  attr_reader :letter, :patient, :doctor, :recipient, :other_recipient_address

  RECIPIENT_TYPES = %w(doctor other patient)

  def initialize(letter)
    @letter = letter
    @patient = letter.patient
    @doctor = patient.doctor
  end

  def update!(params)
    @recipient = params[:recipient]
    @other_recipient_address = params.delete(:other_recipient_address)

    raise 'Invalid recipient type' unless RECIPIENT_TYPES.include?(recipient)

    update_description(params[:letter_description_id])
    update_recipient_address
    update_letter(params)
    letter.save!
  end

  private

  def update_letter(params)
    letter.attributes = params
  end

  def update_description(letter_description_id)
    letter.letter_description = LetterDescription.find(letter_description_id.to_i)
  end

  def update_recipient_address
    letter.recipient_address = send(:"#{recipient}_address")
  end

  def patient_address
    if patient.current_address.present?
      patient.current_address
    elsif patient.address_at_diagnosis.present?
      patient.address_at_diagnosis
    end
  end

  def doctor_address
    return unless doctor.present?
    if doctor.practices.any? && patient.practice.present? && doctor.practices.include?(patient.practice)
      patient.practice.address
    elsif doctor.address.present?
      doctor.address
    end
  end

  def other_address
    if other_recipient_address.present?
      parts = other_recipient_address.split(',')
      parts.map!(&:strip)

      return unless parts.size > 1

      street_1 = parts.first
      postcode = parts.last

      Address.find_or_create_by(street_1: street_1, postcode: postcode) do |addr|
        addr.street_2 = parts.second if parts.size > 2
        addr.city = parts.third if parts.size > 3
        addr.county = parts.fourth if parts.size > 4
      end
    end
  end
end
