# frozen_string_literal: true

require "rails_helper"

describe "Manage letter descriptions", type: :system do
  it "enables a superadmin to list letter descriptions" do
    login_as_super_admin
    description = create(:letter_description, text: "LD1")

    visit letters_descriptions_path

    expect(page).to have_content("Letter Descriptions")
    expect(page).to have_content(description.text)
  end

  it "enables a superadmin to add a letter description" do
    login_as_super_admin

    visit letters_descriptions_path

    within ".page-heading" do
      click_on "Add"
    end

    fill_in "Text", with: "LD123"
    click_on "Create"

    expect(Renalware::Letters::Description.first).to have_attributes(text: "LD123")
  end

  it "enables a superadmin to edit a letter description" do
    login_as_super_admin
    description = create(:letter_description, text: "LD1")

    visit letters_descriptions_path

    within "#letters_description_#{description.id}" do
      click_on "Edit"
    end

    fill_in "Text", with: "LD2"
    click_on "Save"

    expect(Renalware::Letters::Description.first).to have_attributes(text: "LD2")
  end

  it "enables a superadmin to soft-delete a letter description" do
    login_as_super_admin
    description = create(:letter_description, text: "LD1")

    visit letters_descriptions_path

    within "#letters_description_#{description.id}" do
      click_on "Delete"
    end

    expect(Renalware::Letters::Description.count).to eq(0)
    expect(Renalware::Letters::Description.with_deleted.first.deleted_at).not_to be_nil
  end
end
