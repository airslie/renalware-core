# frozen_string_literal: true

require_dependency "renalware/snippets"

#
# This controller handles copying snippets (when I am the owner) and cloning them (when I am not).
# The ownership drives what suffix is appended to the snippet title to keep it unique.
#
module Renalware
  module Snippets
    class SnippetClonesController < BaseController
      skip_after_action :verify_policy_scoped
      COPY_SUFFIX = "[COPY]"
      CLONE_SUFFIX = "[CLONE]"

      def create
        snippet = duplicate_current_snippet
        authorize snippet
        snippet.save!
        redirect_to edit_snippet_path(snippet)
      end

      private

      def duplicate_current_snippet
        title_suffix = title_suffix_to_apply_to_the_duplicate(current_snippet)
        current_snippet.dup.tap do |snippet|
          snippet.author = Snippets.cast_user(current_user)
          snippet.title = snippet_title_generator_for(snippet, title_suffix: title_suffix).call
          snippet.last_used_on = nil
          snippet.times_used = 0
        end
      end

      def current_snippet
        Snippet.find(params[:snippet_id])
      end

      def title_suffix_to_apply_to_the_duplicate(snippet)
        snippet_is_mine?(snippet) ? COPY_SUFFIX : CLONE_SUFFIX
      end

      def snippet_title_generator_for(snippet, title_suffix:)
        DuplicateSnippetTitleGenerator.new(snippet, title_suffix: title_suffix)
      end

      def snippet_is_mine?(snippet)
        snippet.author_id == current_user.id
      end
    end
  end
end
