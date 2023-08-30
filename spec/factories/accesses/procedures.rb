# frozen_string_literal: true

FactoryBot.define do
  factory :access_procedure, class: "Renalware::Accesses::Procedure" do
    type factory: :access_type
    side { :right }
    performed_on { Time.zone.today }
  end
end
