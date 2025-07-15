# frozen_string_literal: true

module Renalware
  class Patients::Timeline
    TIMELINES = [
      Admissions::Admission,
      Clinics::ClinicVisit,
      Events::Event,
      Letters::Letter,
      Messaging::Internal::Message,
      Modalities::Modality
    ].freeze

    FIELDS = [:id].freeze

    def self.all(patient)
      new(TIMELINES.flat_map do |model_class|
        model_class
          .where(patient:)
          .ordered
          .pluck(FIELDS + model_class::ORDER_FIELDS)
          .map do |fields|
            NameService
              .from_model(model_class, to: "TimelineItem")
              .new(id: fields.shift, sort_date: DateTimeHelper.merge(fields))
          end
      end)
    end

    delegate :count, to: :@items

    def initialize(items)
      @items = items.sort_by(&:sort_date).reverse
    end

    def offset(start, limit: 20)
      finish = start + limit - 1
      @items[start..finish].map(&:fetch)
    end
  end
end
