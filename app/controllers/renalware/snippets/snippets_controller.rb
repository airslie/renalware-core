# frozen_string_literal: true

require_dependency "renalware/snippets"

module Renalware
  module Snippets
    class SnippetsController < BaseController
      skip_after_action :verify_policy_scoped

      def index
        authorize Snippet, :index?
        snippets = snippets_for_author(author)
        search = snippets.ransack(params[:q])
        search.sorts = ["times_used desc", "last_used_on desc"] if search.sorts.empty?
        snippets = paginate(search.result, default_per_page: 10)
        render locals: { snippets: snippets, search: search, author: author }
      end

      def new
        authorize(snippet = new_snippet)
        render locals: { snippet: snippet }
      end

      def create
        snippet = Snippet.new(snippet_params)
        snippet.author = Snippets.cast_user(current_user)
        authorize snippet

        if snippet.save
          redirect_to snippets_path, notice: t(".success", model_name: "snippet")
        else
          render :new, locals: { snippet: snippet }
        end
      end

      def edit
        snippet = find_and_authorize_snippet
        render :edit, locals: { snippet: snippet }
      end

      def update
        snippet = find_and_authorize_snippet
        if snippet.update(snippet_params)
          redirect_to snippets_path, notice: t(".success", model_name: "snippet")
        else
          render :edit, locals: { snippet: snippet }
        end
      end

      def destroy
        snippet = find_and_authorize_snippet
        snippet.destroy!
        flash[:notice] = success_msg_for("snippet")
        redirect_to snippets_path
      end

      private

      def snippets_for_author(author)
        user = author == :me ? current_user : nil
        SnippetQuery.new(author: user).call
      end

      def author
        @author ||= begin
          author = params.fetch(:author, :me).to_sym
          author = :me unless [:me, :anyone].include?(author)
          author
        end
      end

      def new_snippet
        id = params[:id_of_snippet_to_duplicate]
        id.present? ? duplicate_snippet(id) : Snippet.new
      end

      def duplicate_snippet(id)
        original_snippet = Snippet.find(id)
        Snippet.new(title: original_snippet.title, body: original_snippet.body)
      end

      def find_and_authorize_snippet
        snippet = Snippet.find(params[:id])
        authorize snippet
        snippet
      end

      def snippet_params
        params.require(:snippet).permit([:title, :body])
      end
    end
  end
end
