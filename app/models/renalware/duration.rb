module Renalware
  class Duration
    def initialize(value)
      @seconds = value.is_a?(::String) ? to_seconds(value) : value
    end

    def in_seconds
      @seconds
    end

    def to_s
      return nil if @seconds.nil?

      hours, seconds = @seconds.divmod(3600)
      minutes = seconds / 60
      sprintf("%d:%02d", hours, minutes)
    end

    private

    def to_seconds(data)
      return if data.blank?

      value = data.to_s
      if value =~ /:/
        hours, minutes = value.split(":")
        hours.to_i * 60 * 60 + minutes.to_i * 60
      else
        value.to_i * 60
      end
    end
  end
end