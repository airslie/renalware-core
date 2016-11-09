module Renalware
  module Letters
    class HTMLRenderer
      def call(letter)
        context = LettersController.new
        context.render_to_string(
          partial: "/renalware/letters/formatted_letters/letter",
          locals: { letter: letter }
        )
      end
    end
  end
end
