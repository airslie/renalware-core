# frozen_string_literal: true

module Renalware
  # The useful thing here is that we're ensuring all the classes
  # actually exist so if anything gets renamed this spec will flag it.
  RSpec.describe NameService do
    [
      # Timeline
      %w(Admissions::Admission Admissions::TimelineItem Admissions::TimelineRow),
      %w(Clinics::ClinicVisit Clinics::TimelineItem Clinics::TimelineRow),
      %w(Events::Event Events::TimelineItem Events::TimelineRow),
      %w(Letters::Letter Letters::TimelineItem Letters::TimelineRow),
      %w(Modalities::Modality Modalities::TimelineItem Modalities::TimelineRow),
      %w(Messaging::Internal::Message
         Messaging::Internal::TimelineItem
         Messaging::Internal::TimelineRow)
    ].each do |model, service, component|
      it "maps #{model} to #{service} and #{component}" do
        # Add in Renalware namespace after to keep down the noise in spec name
        model = "Renalware::#{model}".constantize
        service = "Renalware::#{service}".constantize
        component = "Renalware::#{component}".constantize

        klass = described_class.from_model(model, to: "TimelineItem")
        expect(klass).to eq service

        klass = described_class.from_model(model, to: "TimelineRow")
        expect(klass).to eq component
      end
    end

    [
      # Toggled Cell
      %w(RemoteMonitoring::Registration RemoteMonitoring::Registration::Detail)
    ].each do |model, component|
      it "maps #{model} to #{component}" do
        model = "Renalware::#{model}".constantize
        component = "Renalware::#{component}".constantize

        klass = described_class.from_model(model, to: "Detail", keep_class: true)
        expect(klass).to eq component
      end
    end

    it "maps a letter state class" do
      model = Letters::Letter::Draft.new

      klass = described_class.from_model(model, to: "TimelineItem")
      expect(klass).to eq Letters::TimelineItem

      klass = described_class.from_model(model, to: "TimelineRow")
      expect(klass).to eq Letters::TimelineRow
    end

    it "maps an event class" do
      model = RemoteMonitoring::Registration.new

      klass = described_class.from_model(model, to: "TimelineItem")
      expect(klass).to eq Events::TimelineItem

      klass = described_class.from_model(model, to: "TimelineRow")
      expect(klass).to eq Events::TimelineRow
    end

    it "maps an event class detail component" do
      model = RemoteMonitoring::Registration.new

      klass = described_class.from_model(model, to: "Detail", keep_class: true)
      expect(klass).to eq RemoteMonitoring::Registration::Detail
    end
  end
end
