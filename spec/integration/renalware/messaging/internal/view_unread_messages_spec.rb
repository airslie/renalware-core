# frozen_string_literal: true

require "rails_helper"

RSpec.describe "View internal messages sent by the current", type: :request do
  describe "GET index" do
    it "responds successfully" do
      get messaging_internal_inbox_path

      expect(response).to be_successful
    end
  end
end
