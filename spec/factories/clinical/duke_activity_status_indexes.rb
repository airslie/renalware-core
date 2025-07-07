# frozen_string_literal: true

FactoryBot.define do
  factory :duke_activity_status_index, class: "Renalware::Clinical::DukeActivityStatusIndex" do
    accountable
    patient
    date_time { Time.current }
    event_type factory: :duke_activity_status_index_event_type
    document { { score: 1 } }
  end
end
