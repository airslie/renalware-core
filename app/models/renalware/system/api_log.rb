# frozen_string_literal: true

require "benchmark"

module Renalware
  module System
    class APILog < ApplicationRecord
      validates :identifier, presence: true
      validates :status, presence: true
      STATUS_WORKING = "working"
      STATUS_DONE = "done"
      STATUS_ERROR = "error"

      def self.with_log(identifier, **)
        log = create!(identifier: identifier, status: STATUS_WORKING, **)
        elapsed_ms = Benchmark.ms { yield(log) } if block_given?
        log.update!(status: STATUS_DONE, elapsed_ms: elapsed_ms)
        log
      rescue StandardError => e
        log.update(
          status: STATUS_ERROR,
          error: "#{$ERROR_INFO}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}"
        )
        raise e
      end
    end
  end
end
