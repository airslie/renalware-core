# frozen_string_literal: true

require "rails_helper"

RSpec.describe "File Import viewing and uploading", type: :feature do
  describe "Listing file imports" do
    it "responds successfully with a paginated list of file imports" do
      user = create(:user)
      type = create(:feed_file_type, name: "Practices")
      create(
        :feed_file,
        file_type: type,
        created_by: user,
        updated_by: user,
        location: file_fixture("practices/fullfile.zip")
      )

      login_as_clinical
      visit admin_feeds_files_path

      expect(page).to have_content(user.family_name)
      expect(page).to have_content(type.name)
    end
  end

  describe "Uploading a file import" do
    it "works" do
      pending
      fail NotImplementedError
    end
  end
end
