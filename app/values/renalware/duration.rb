module Renalware
  class Duration
    attr_reader :seconds

    def initialize(seconds)
      @seconds = seconds
    end

    def self.from_string(value)
      Duration.new(to_seconds(value))
    end

    def to_s
      return "" if @seconds.nil?

      hours, seconds = @seconds.divmod(3600)
      minutes = seconds / 60
      sprintf("%d:%02d", hours, minutes)
    end

    private

    def self.to_seconds(string)
      return nil if string.blank?

      if string =~ /:/
        hours, minutes = string.split(":")
        (hours.to_i * 60 * 60) + (minutes.to_i * 60)
      else
        string.to_i * 60
      end
    end
  end
end