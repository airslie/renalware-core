module Renalware
  class StepIndicatorComponent < ApplicationComponent
    Step = Data.define(:key, :label)

    attr_reader :current_step, :steps

    def initialize(steps:, current_step:)
      super()
      @steps = steps.map do |step|
        Step.new(key: step.fetch(:key).to_sym, label: step.fetch(:label))
      end
      @current_step = current_step.to_sym
    end

    def state_for(step)
      if step.key == current_step
        :current
      elsif step_index(step) < current_step_index
        :complete
      else
        :upcoming
      end
    end

    def item_classes(step)
      [
        "flex-1",
        "text-center",
        "font-medium",
        state_for(step) == :upcoming ? "text-gray-500" : "text-gray-900"
      ]
    end

    def marker_classes(step)
      [
        "mx-auto",
        "mb-2",
        "flex",
        "h-8",
        "w-8",
        "items-center",
        "justify-center",
        "rounded-full",
        "border-2",
        marker_state_classes(step)
      ]
    end

    def connector_classes(step)
      [
        "absolute",
        "left-1/2",
        "top-4",
        "h-0.5",
        "w-full",
        state_for(step) == :complete ? "bg-green-600" : "bg-gray-300"
      ]
    end

    def last_step?(step) = step == steps.last

    private

    def current_step_index
      @current_step_index ||= steps.index { |step| step.key == current_step } || 0
    end

    def step_index(step) = steps.index(step)

    def marker_state_classes(step)
      case state_for(step)
      when :complete
        "border-green-600 bg-green-600 text-white"
      when :current
        "border-blue-600 bg-white text-blue-700"
      else
        "border-gray-300 bg-white text-gray-500"
      end
    end
  end
end
