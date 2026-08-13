require "rails_helper"

module Renalware
  module Transplants
    describe "Wait lists" do
      around do |example|
        original_value = Renalware.config.display_nhsbt_wait_list_upload
        example.run
      ensure
        Renalware.config.display_nhsbt_wait_list_upload = original_value
      end

      it "shows the NHSBT wait list upload link when enabled" do
        Renalware.config.display_nhsbt_wait_list_upload = true
        login_as_admin

        get transplants_wait_list_path(named_filter: "active")

        expect(response.body).to include("Upload NHSBT Wait List")
      end

      it "hides the NHSBT wait list upload link when disabled" do
        Renalware.config.display_nhsbt_wait_list_upload = false
        login_as_admin

        get transplants_wait_list_path(named_filter: "active")

        expect(response.body).not_to include("Upload NHSBT Wait List")
      end
    end
  end
end
