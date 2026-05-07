# frozen_string_literal: true

require "roo"

module Renalware
  module Heroic
    module BioBank
      class SampleUploadsController < Renalware::BaseController
        def new
          upload = Upload.new
          authorize upload
          render_new(upload)
        end

        def create
          upload = Upload.new(upload_params)
          authorize upload
          if spreadsheet_valid?(upload)
            GenerateUploadPreview.new(upload, current_user).call
            redirect_to heroic.edit_bio_bank_sample_upload_path(upload)
          else
            render_new(upload)
          end
        end

        def edit
          render locals: { upload: find_and_authorize_upload }
        end

        def show
          upload = Upload.includes(aliquots: { sample: [:patient, :sample_type] }).find(params[:id])
          authorize upload
          render locals: { upload: UploadPresenter.new(upload) }
        end

        def update
          upload = find_and_authorize_upload
          CreateSamplesFromUpload.new(upload, current_user).call
          redirect_to heroic.bio_bank_sample_upload_path(upload)
        end

        private

        def spreadsheet_valid?(upload)
          validate_spreadsheet_content(upload)
          upload.errors.blank? && upload.save_by(current_user)
        end

        def validate_spreadsheet_content(upload)
          file = params.dig(:upload, :file)
          return if file.blank?

          validator = ValidateSamplesSpreadsheet.new(file.path, upload)
          validator.call
          upload.errors[:base].concat(validator.errors)
        end

        def render_new(upload)
          render :new, locals: { upload: upload }
        end

        def find_and_authorize_upload
          Upload.find(params[:id]).tap { |upload| authorize upload }
        end

        def upload_params
          params.require(:upload).permit(:file)
        end
      end
    end
  end
end
