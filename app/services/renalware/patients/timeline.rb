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
              .fetch
          end
      end)
    end

    delegate :count, to: :@items

    def initialize(items)
      @items = items.sort_by(&:sort_date).reverse
    end

    def page(number, limit: 20)
      finish = (limit * number)
      start = finish - limit
      @items[start..finish - 1]
    end
  end
end
