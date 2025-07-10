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
            id = fields.shift
            sort_date = Renalware::DateTimeHelper.merge(fields)
            timeline_item(model_class, id, sort_date).fetch
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

    private_class_method def self.timeline_item(model_class, id, sort_date)
      NameService.from_model(model_class, to: "TimelineItem").new(id:, sort_date:)
    end
  end
end
