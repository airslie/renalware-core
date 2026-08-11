module Renalware
  module Transplants
    class NHSBTWaitListUploadsController < BaseController
      def show
        upload = find_and_authorize_upload
        pagy, rows = paginated_rows(upload)

        render locals: { upload:, rows:, pagy: }
      end

      def new
        authorize NHSBTWaitListUpload
        render locals: { form: NHSBTWaitListUploadForm.new, last_imported_upload: }
      end

      def create
        authorize NHSBTWaitListUpload

        form = NHSBTWaitListUploadForm.new(upload_params)
        return render_new(form) unless form.valid?

        # Malware scanning belongs here, after basic file validation and before parsing.
        rows = NHSBT::WaitListParser.new(form.path).call
        preview_rows = NHSBT::WaitListPreview.new(rows).call
        upload = build_upload(form, preview_rows)
        upload.save_by!(current_user)

        redirect_to transplants_nhsbt_wait_list_upload_path(upload)
      rescue NHSBT::WaitListParser::InvalidCSV => e
        form.errors.add(:base, e.message)
        render_new(form)
      end

      def import
        upload = find_and_authorize_upload
        return redirect_to transplants_nhsbt_wait_list_upload_path(upload) if upload.imported?

        NHSBT::WaitListImporter.new(upload:, by: current_user).call

        redirect_to transplants_nhsbt_wait_list_upload_path(upload)
      end

      private

      def build_upload(form, rows)
        NHSBTWaitListUpload.new(
          filename: form.filename,
          rows:,
          matched_count: rows.count { |row| row["matched"] },
          unmatched_count: rows.count { |row| !row["matched"] }
        )
      end

      def find_and_authorize_upload
        NHSBTWaitListUpload.find(params[:id]).tap { |upload| authorize upload }
      end

      def render_new(form)
        render :new, locals: { form:, last_imported_upload: }
      end

      def last_imported_upload
        NHSBTWaitListUpload
          .imported
          .where.not(imported_at: nil)
          .order(imported_at: :desc, id: :desc)
          .first
      end

      def paginated_rows(upload)
        rows = upload.rows.sort_by { |row| sort_key(row) }
        pagy = Pagy::Offset.new(
          count: rows.length,
          page: params[:page],
          limit: 25,
          request:
        )

        [pagy, rows.slice(pagy.offset, pagy.limit) || []]
      end

      def sort_key(row)
        [
          row["matched"] ? 1 : 0,
          row["patient_family_name"].to_s.downcase,
          row["patient_given_name"].to_s.downcase,
          row["recip_id"].to_s
        ]
      end

      def upload_params
        params.fetch(:transplants_nhsbt_wait_list_upload_form, {}).permit(:file)
      end
    end
  end
end
