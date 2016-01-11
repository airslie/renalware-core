module Renalware
  class Duration
    attr_reader :seconds

    class Minute
      def self.to_seconds(value);  value.to_i * 60; end
    end

    class Hour
      def self.to_seconds(value); value.to_i * Minute.to_seconds(60); end
    end

    def initialize(seconds)
      @seconds = seconds
    end

    def self.from_string(value)
      Duration.new(to_seconds(value))
    end

    # Returns the duration in hours and minutes format: "hh:mm"
    def to_s
      return "" if @seconds.nil?

      hours, seconds = @seconds.divmod(Hour.to_seconds(1))
      minutes = seconds / Minute.to_seconds(1)
      sprintf("%d:%02d", hours, minutes)
    end

    private

    def self.to_seconds(string)
      return nil if string.blank?

      # Expected format: "hh:mm"
      if string =~ /:/
        hours, minutes = string.split(":")
        Hour.to_seconds(hours) + Minute.to_seconds(minutes)
      else
        Minute.to_seconds(string)
      end
    end
  end
end