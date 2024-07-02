# frozen_string_literal: true

module World
  module Snippeting::Snippet
    module Domain
      def create_snippet_for(user, title:, body:)
        seed_snippet(user: user, title: title, body: body)
      end

      def seed_snippet(user:, title:, body:)
        author = snippets_user(user)
        Renalware::Snippeting::Snippet.create(author: author, title: title, body: body)
      end

      def expect_user_to_have_snippet(user, title:, body:)
        expect(
          Renalware::Snippeting::Snippet.where(author: user, title: title, body: body).count
        ).to eq(1)
      end
    end

    module Web
      include Domain

      def create_snippet_for(user, title:, body:)
        login_as user
        visit snippeting.snippets_path

        click_on "Create new snippet"
        fill_in "Title", with: title
        fill_in "Body", with: body
        click_on t("btn.save")

        expect(page).to have_current_path(snippeting.snippets_path)
      end

      def expect_user_to_have_snippet(_user, title:, body:)
        within "table.snippets" do
          expect(page).to have_content(title)
        end
      end
    end
  end
end
