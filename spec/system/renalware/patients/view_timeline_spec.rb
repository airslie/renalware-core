RSpec.describe "A user views the timeline" do
  it "views the timeline" do
    user = create(:user, :clinical)
    patient = create(:patient, by: user)
    login_as user

    visit patient_path(patient)

    click_on "Timeline"

    expect(page).to have_content "Timeline"
  end
end
