# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
describe "Creating a mailshot", type: :system, js: true do
  def create_test_sql_view(name = "letter_mailshot_test")
    ActiveRecord::Base.connection.execute(Arel.sql(<<-SQL))
      create or replace view #{name}
      as select id as patient_id from patients;
    SQL
  end

  it "the happy path" do
    test_description = "Test mailshot"
    patient = create(
      :patient,
      family_name: "JONES",
      given_name: "Jack",
      nhs_number: "0123456789",
      sex: "M"
    )
    create_test_sql_view
    user = login_as_super_admin
    create(:letter_letterhead, name: "MyLetterhead")

    visit admin_dashboard_path

    within ".side-nav--admin" do
      click_on "Mailshots"
    end

    within ".page-actions" do
      click_on "Add"
    end

    expect(page).to have_content("New mailshot")
    fill_in "Description", with: test_description
    select "MyLetterhead", from: "Letterhead"

    # Selecting a sql view will populate the patient preview div via ajax
    select "letter_mailshot_test", from: "Sql view name"

    expect(page).to have_css("#mailshot-patients-preview tbody tr")
    within("#mailshot-patients-preview") do
      expect(page).to have_content("JONES, Jack")
      expect(page).to have_content("0123456789")
    end

    select(user.to_s, from: "Author")
    fill_trix_editor with: "This is the body of the letter"
    accept_alert do
      click_on "Send"
    end

    expect(page).to have_current_path(letters_mailshots_path)

    within("table.mailshots") do
      expect(page).to have_content(I18n.l(Time.zone.today)) # the date part of created_at
      expect(page).to have_content("Test mailshot") # description
      expect(page).to have_content(user.to_s) # author
    end

    # Check the letter was created
    expect(Renalware::Letters::Letter.first).to have_attributes(
      description: test_description,
      patient_id: patient.id,
      author: user,
      type: "Renalware::Letters::Letter::Approved",
      salutation: "Dear Jack JONES"
    )

    # Check we created a mailshot and child mailshot_letters
    mailshot = Renalware::Letters::Mailshots::Mailshot.last
    expect(mailshot).to have_attributes(
      description: test_description,
      letters_count: 1
    )
    expect(Renalware::Letters::Mailshots::Item.count).to eq(1)
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
