class DoctorEmailValidator < ActiveModel::Validator
  def validate(record)
    # Check for an email address
    return if record.present? && record.email.present?
    # Check for practices with an email address
    return if record.practices.any? && record.practices.map(&:email).any?

    record.errors[:email] << 'Must have an email address or an contact email address at a practice.'
  end
end
