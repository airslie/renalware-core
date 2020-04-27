# frozen_string_literal: true

FactoryBot.define do
  factory :pd_adequacy_result, class: "Renalware::PD::AdequacyResult" do
    accountable
    performed_on { I18n.l(Time.zone.today) }
  end
end
