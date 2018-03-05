# frozen_string_literal: true

module ExceptionNotification
  class Notifier
    def notify(_error)
      raise NotImplementedError
    end
  end
end
