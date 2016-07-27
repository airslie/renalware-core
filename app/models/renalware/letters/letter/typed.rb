require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Typed < Letter
      def self.policy_class
        TypedLetterPolicy
      end

      def archive(by:, renderer: HTMLRenderer)
        becomes!(Archived).tap do |letter|
          letter.by = by
          letter.build_archive(created_by: by)
          letter.archive.content = renderer.new.call(self)
        end
      end

      class HTMLRenderer
        def call(letter)
          context = Renalware::Letters::LettersController.new()
          presented_letter = LetterPresenterFactory.new(letter)
          context.render_to_string(
            partial: "/renalware/letters/formatted_letters/letter",
            locals: { letter: presented_letter}
          )
        end
      end
    end
  end
end
