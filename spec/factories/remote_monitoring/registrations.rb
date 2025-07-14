FactoryBot.define do
  factory :remote_monitoring_registration, class: "Renalware::RemoteMonitoring::Registration" do
    accountable
    patient
    event_type factory: :remote_monitoring_registration_event_type
    date_time { Time.current }
    document { { frequency_iso8601: "P4M" } }
  end
end
