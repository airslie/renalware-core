# frozen_string_literal: true

module Renalware
  module System
    class DownloadsController < BaseController
      include Concerns::Pageable

      def index
        query = DownloadQuery.new(params[:q])
        items = query.call.page(page).per(per_page)
        authorize items
        render locals: { items: items, search: query.search }
      end

      def new
        download = Download.new
        authorize download
        render_new(download)
      end

      def create
        download = Download.new(download_params)
        authorize download
        if download.save_by(current_user)
          redirect_to system_downloads_path, notice: notice
        else
          render_new(download)
        end
      end

      def edit
        render_edit(find_and_authorize_download)
      end

      def update
        download = find_and_authorize_download
        if download.update_by(current_user, download_params)
          redirect_to system_downloads_path, notice: notice
        else
          render_edit(download)
        end
      end

      def destroy
        download = find_and_authorize_download
        download.destroy!
        redirect_to system_downloads_path, notice: notice
      end

      # Redirects the uploaded file eg PDF etc
      def show
        download = find_and_authorize_download
        if download.file.attached?
          update_view_count_for download
          redirect_to(raw_active_storage_url_for(download.file))
        end
      end

      private

      def render_new(download)
        render :new, locals: { download: download }
      end

      def render_edit(download)
        render :edit, locals: { download: download }
      end

      def find_and_authorize_download
        Download.find(params[:id]).tap { |download| authorize download }
      end

      def download_params
        params.require(:download).permit(:name, :description, :file)
      end

      def notice
        t(".success", model_name: "download")
      end

      def update_view_count_for(download)
        download.update_column(:view_count, download.view_count + 1)
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
