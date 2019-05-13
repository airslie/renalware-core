# frozen_string_literal: true

module Renalware
  module System
    class HelpController < BaseController
      include Concerns::Pageable

      def index
        query = HelpQuery.new(params[:q])
        items = query.call.page(page).per(per_page)
        authorize items
        render locals: { items: items, search: query.search }
      end

      def new
        help_item = Help.new
        authorize help_item
        render_new(help_item)
      end

      def create
        help = Help.new(help_params)
        authorize help
        if help.save_by(current_user)
          redirect_to system_help_index_path, notice: notice
        else
          render_new(help)
        end
      end

      def edit
        render_edit(find_and_authorize_help)
      end

      def update
        help = find_and_authorize_help
        if help.update_by(current_user, help_params)
          redirect_to system_help_index_path, notice: notice
        else
          render_edit(help)
        end
      end

      def destroy
        help = find_and_authorize_help
        help.destroy!
        redirect_to system_help_index_path, notice: notice
      end

      # Redirects the uploaded file eg PDF etc
      def show
        item = find_and_authorize_help
        if item.file.attached?
          update_view_count_for item
          redirect_to(raw_active_storage_url_for(item.file))
        end
      end

      private

      def render_new(help_item)
        render :new, locals: { help_item: help_item }
      end

      def render_edit(help_item)
        render :edit, locals: { help_item: help_item }
      end

      def find_and_authorize_help
        Help.find(params[:id]).tap { |help| authorize help }
      end

      def help_params
        params.require(:help).permit(:name, :description, :file)
      end

      def notice
        t(".success", model_name: "Help item")
      end

      def update_view_count_for(item)
        item.update_column(:view_count, item.view_count + 1)
      end

      def raw_active_storage_url_for(file)
        Rails.application.routes.url_for(
          controller: "active_storage/blobs",
          action: :show,
          signed_id: file.signed_id,
          filename: file.filename,
          only_path: true
        )
      end
    end
  end
end
