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
            date = Renalware::DateTimeHelper.merge(fields)
            timeline_item_class_from(model_class).new(id, date)
          end
      end)
    end

    delegate :count, to: :@items

    def initialize(items)
      @items = items.sort_by(&:date).reverse
    end

    def page(number, limit: 20)
      finish = (limit * number)
      start = finish - limit
      @items[start..finish - 1]
    end

    private_class_method def self.timeline_item_class_from(model_class)
      parts = model_class.name.split("::")[0..-2].join("::")
      "#{parts}::TimelineItem".constantize
    end
  end
end
