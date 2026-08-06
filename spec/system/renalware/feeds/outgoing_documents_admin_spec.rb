describe "Outgoing document management" do
  it "allows listing outgoing documents for a superadmin" do
    user = login_as_super_admin
    event = create(:swab, by: user)
    doc = Renalware::Feeds::OutgoingDocument.create!(
      renderable: event,
      by: user,
      created_at: 1.day.ago,
      state: :errored,
      error_code: "TIE_TIMEOUT",
      error: "Timed out waiting for TIE response"
    )

    visit feeds_outgoing_documents_path(format: :html)

    expect(page).to have_text("Outgoing Documents")
    expect(page).to have_text(user.to_s)
    expect(page).to have_text(doc.id)
    expect(page).to have_text(doc.state)
    expect(page).to have_text("TIE_TIMEOUT - Timed out waiting for TIE response")
  end

  it "orders filtered outgoing documents by created date descending by default" do
    user = login_as_super_admin
    event = create(:swab, by: user)
    older_doc = Renalware::Feeds::OutgoingDocument.create!(
      renderable: event,
      by: user,
      created_at: 2.days.ago
    )
    newer_doc = Renalware::Feeds::OutgoingDocument.create!(
      renderable: event,
      by: user,
      created_at: 1.day.ago
    )

    visit feeds_outgoing_documents_path(format: :html)
    click_on "Filter"

    document_ids = all("table tbody tr").map { |row| row.first("td").text.to_i }
    expect(document_ids).to eq([newer_doc.id, older_doc.id])
  end
end
