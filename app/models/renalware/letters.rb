# frozen_string_literal: true

module Renalware::Letters
  def self.table_name_prefix = "letter_"

  def self.cast_author(user)
    ActiveType.cast(user, Author, force: Renalware.config.force_cast_active_types)
  end

  def self.cast_typist(user)
    ActiveType.cast(user, Typist, force: Renalware.config.force_cast_active_types)
  end

  def self.cast_patient(patient)
    ActiveType.cast(
      patient,
      ::Renalware::Letters::Patient,
      force: Renalware.config.force_cast_active_types
    )
  end

  def self.cast_primary_care_physician(primary_care_physician)
    ActiveType.cast(
      primary_care_physician,
      ::Renalware::Letters::PrimaryCarePhysician,
      force: Renalware.config.force_cast_active_types
    )
  end

  module Delivery
  end

  module Mailshots
    def self.table_name_prefix = "letter_mailshot_"
  end
end
