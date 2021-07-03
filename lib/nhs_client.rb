# frozen_string_literal: true

require "httparty"

# Usage:
#
#   client = NHSClient.new
#   client.query('test')
#   client.problems
#
class NHSClient
  NHS_BASE_URL = "https://ontology.nhs.uk"
  TOKEN_REQUEST_PATH = "authorisation/auth/realms/nhs-digital-terminology/protocol/openid-connect/token"
  QUERY_PATH = "production1/fhir/ValueSet/$expand"

  # rubocop:disable Rails/EnvironmentVariableAccess
  CLIENT_ID = ENV["NHS_CLIENT_ID"]
  CLIENT_SECRET = ENV["NHS_CLIENT_SECRET"]
  # rubocop:enable Rails/EnvironmentVariableAccess

  attr_reader :problems

  def initialize
    @problems = []
  end

  def api_enabled?
    (CLIENT_ID && CLIENT_SECRET).present?
  end

  def query(filter, count: 20, include_designations: false)
    return false unless (token = bearer_token)

    response = HTTParty.get(
      "#{NHS_BASE_URL}/#{QUERY_PATH}",
      headers: {
        "Authorization" => "Bearer #{token}"
      },
      query: {
        url: "http://snomed.info/sct?fhir_vs=ecl/<404684003",
        filter: filter,
        count: count,
        includeDesignations: include_designations
      }
    )

    return false unless response.code == 200

    response_body = JSON.parse(response.body)
    @problems = response_body["expansion"]["contains"]&.map { |h| h.slice("code", "display") } || []

    response_body
  end

  private

  def bearer_token
    response = HTTParty.post(
      "#{NHS_BASE_URL}/#{TOKEN_REQUEST_PATH}",
      headers: {
        "Content-Type" => "application/x-www-form-urlencoded"
      },
      body: {
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        grant_type: "client_credentials"
      }
    )

    return false unless response.code == 200

    JSON.parse(response.body)["access_token"]
  end
end
