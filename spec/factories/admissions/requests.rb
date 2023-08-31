# frozen_string_literal: true

FactoryBot.define do
  factory :admissions_request, class: "Renalware::Admissions::Request" do
    accountable
    reason factory: %i(admissions_request_reason)
    patient { create(:patient, by: accountable_actor) } # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
    priority { :low }
  end
end
