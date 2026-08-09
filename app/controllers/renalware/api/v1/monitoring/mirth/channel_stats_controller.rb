module Renalware
  module API
    module V1
      module Monitoring
        module Mirth
          class ChannelStatsController < TokenAuthenticatedAPIController
            api_scope Credential::MIRTH_STATISTICS_WRITE
            disable_legacy_query_authentication

            skip_before_action :verify_authenticity_token

            def create
              result = Renalware::Monitoring::Mirth::IngestChannelStats.call(
                attributes: payload_params,
                api_credential: current_api_credential
              )

              render_result(result)
            rescue Renalware::Monitoring::Mirth::IngestChannelStats::InvalidPayload => e
              render json: { errors: e.errors }, status: :unprocessable_content
            end

            private

            def payload_params
              params.permit(
                :schema_version,
                :report_id,
                :reported_at,
                :source,
                :site_id,
                :instance_id,
                :server_id,
                channels: %i(id name state received sent error filtered queued)
              ).to_h
            end

            def render_result(result)
              status = result.created? ? :created : :ok
              render(
                json: {
                  report_id: result.report.report_id,
                  status: result.created? ? "accepted" : "duplicate"
                },
                status:
              )
            end
          end
        end
      end
    end
  end
end
