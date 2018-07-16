# frozen_string_literal: true

require "rails_helper"

RSpec.describe "View transmission logs", type: :feature do
  describe "GET index" do
    it "displays a paginated list of transmission logs, most recent first" do
      login_as_admin
      log_1 = create(:hd_transmission_log, :incoming_xml, payload: "log_1")
      create(:hd_transmission_log, :outgoing_hl7, payload: "log_2")

      visit hd_transmission_logs_path(per_page: 1)

      expect(page).to have_content("HD Transmission Logs")

      within ".hd_transmission_logs" do
        expect(page).to have_content("log_1")
        expect(page).to have_content(log_1.direction)
        expect(page).to have_content(log_1.format)
        expect(page).not_to have_content("log_2")
        expect(page).to have_content("Next ")
      end
    end
  end
end
