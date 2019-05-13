# frozen_string_literal: true

require "rails_helper"

describe "Managing help files", type: :system do
  it "creating a new help item" do
    login_as_super_admin
    visit new_system_help_path
    fill_in "Name", with: "Low sodium dietry advice"
    fill_in "Description", with: "A description"
    attach_file "File", file_fixture("dog.jpg")

    click_on "Save"

    help = Renalware::System::Help.last
    expect(help).to have_attributes(
      name: "Low sodium dietry advice",
      description: "A description"
    )
    expect(help.file).to be_attached
  end

  it "editing a help item" do
    login_as_super_admin
    create(:system_help, :with_file, name: "HelpName1", description: "HelpDescription1")
    visit system_help_index_path
    within(".help-item") { click_on "Edit" }

    fill_in "Name", with: "Updated name"
    click_on "Save"

    within(".help-item") do
      expect(page).to have_content("Updated name")
    end
  end

  it "deleting a help item" do
    login_as_super_admin
    create(:system_help, :with_file, name: "HelpName1", description: "Description1")
    visit system_help_index_path
    within(".help-item") { click_on "Delete" }

    expect(page).not_to have_css(".help-item")
  end

  it "listing items" do
    login_as_super_admin
    create(:system_help, :with_file, name: "HelpName1", description: "Description1")
    visit system_help_index_path

    expect(page).to have_content("HelpName1")
    expect(page).to have_content("Description1")
    expect(page).to have_content("View")
  end

  it "filtering items" do
    login_as_super_admin
    create(:system_help, :with_file, name: "Name1", description: "Description1")
    create(:system_help, :with_file, name: "Name2", description: "Description2")
    visit system_help_index_path

    expect(page).to have_css(".help-item", count: 2)

    within ".filters" do
      fill_in "q_name_or_description_cont", with: "Name2"
      click_on "Search"
    end

    expect(page).to have_css(".help-item", count: 1)
    expect(page).to have_content("Description2")
  end

  describe "viewing an attachment" do
    it "clicking on the name opens the attachment in a new window using & increments view_count" do
      login_as_super_admin
      item = create(:system_help, :with_file, name: "Name1", description: "Description1")
      visit system_help_index_path

      within(".help-item") do
        click_on "Name1"
      end

      expect(page).to have_current_path(%r{rails/active_storage.*})
      expect(item.reload.view_count).to eq(1)
    end
  end
end
