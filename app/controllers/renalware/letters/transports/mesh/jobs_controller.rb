# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class JobsController < BaseController
      include Pagy::Backend

      def index
        authorize Transmission, :index?
        query = GoodJob::Job.where(queue_name: "transfer_of_care").order(updated_at: :desc)
        pagy, jobs = pagy(query, items: 30)
        render locals: { pagy: pagy, jobs: jobs, stats: stats_hash }
      end

      private

      def stats_hash
        jobs = GoodJob::Job.where(queue_name: "transfer_of_care")
        {
          queued: ["", jobs.where(performed_at: nil).count],
          succeeded: ["bg-green-100", jobs.where.not(finished_at: nil).where(error: nil).count],
          failed: ["bg-red-100", jobs.where.not(finished_at: nil).where.not(error: nil).count]
        }
      end
    end
  end
end
