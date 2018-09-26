# frozen_string_literal: true

module Renalware
  module Letters
    # Note we cannot use a partial layout with render_to_string as it will always expect
    # the location to be in views/layouts and its not possible in Rails 5.1 to specify
    # another or absolute path
    class HTMLRenderer
      def call(letter)
        context = LettersController.new
        context.render_to_string(
          partial: "/renalware/letters/formatted_letters/letter",
          locals: { letter: letter },
          encoding: "UTF-8"
        )
      end
    end
  end
end
