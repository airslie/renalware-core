# frozen_string_literal: true

FactoryBot.define do
  factory :transplant_registration_status, class: "Renalware::Transplants::RegistrationStatus" do
    accountable
    description { create(:transplant_registration_status_description) } # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
    started_on { Time.zone.today }
  end
end
