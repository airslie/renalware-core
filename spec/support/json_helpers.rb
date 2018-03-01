# frozen_string_literal: true

module JsonHelpers
  def json_response
    JSON.parse(response.body)
  end
end
