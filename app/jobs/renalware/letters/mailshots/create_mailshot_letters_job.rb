# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Mailshots
      class CreateMailshotLettersJob < ApplicationJob
        def perform(mailshot)
          mailshot.update_column(:status, :processing)
          mailshot.create_letters
          mailshot.update_column(:status, :success)
        rescue StandardError => e
          mailshot.update_columns(
            last_error: "#{$ERROR_INFO}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}",
            status: :failure
          )
          raise e
        end
      end
    end
  end
end
