class Renalware::Transplants::RegistrationStatus < ActiveRecord::Base
  belongs_to :registration
  belongs_to :description, class_name: "RegistrationStatusDescription"

  def terminated?
    terminated_on.present?
  end

  def to_s
    description.name
  end
end
