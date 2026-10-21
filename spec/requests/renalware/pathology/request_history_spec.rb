describe "Pathology request form print history" do
  let(:patient) { create(:pathology_patient) }
  let(:clinic) { create(:clinic) }
  let(:consultant) { create(:consultant) }
  let(:printed_at) { Time.zone.local(2026, 1, 15, 12) }

  it "shows 20 newest records then the remaining records without overlap" do
    records = create_history(23)

    get pathology_requests_requests_path

    expect(response).to be_successful
    expect(history_links).to eq(pdf_paths(records.first(20)))
    next_url = response.parsed_body.at_css('a[rel="next"]')["href"]
    get next_url

    expect(response).to be_successful
    expect(history_links).to eq(pdf_paths(records.drop(20)))
  end

  it "honours custom page sizes and preserves them in navigation links" do
    records = create_history(5)

    get pathology_requests_requests_path, params: { per_page: 2 }
    expect(history_links).to eq(pdf_paths(records.first(2)))
    get response.parsed_body.at_css('a[rel="next"]')["href"]

    expect(response).to be_successful
    expect(history_links).to eq(pdf_paths(records.slice(2, 2)))
  end

  it "keeps the printed-on filter when following the next page link" do
    records = create_history(21)
    create_history(1, at: printed_at + 1.day)
    create_history(1, at: printed_at - 1.day)

    get pathology_requests_requests_path,
        params: { q: { created_on_eq: "15-01-2026" } }

    expect(response).to be_successful
    expect(history_links).to eq(pdf_paths(records.first(20)))
    get response.parsed_body.at_css('a[rel="next"]')["href"]

    expect(response).to be_successful
    expect(history_links).to eq(pdf_paths(records.last(1)))
  end

  it "renders the empty state when no requests exist" do
    get pathology_requests_requests_path

    expect_empty_history
  end

  it "renders the empty state when the date filter matches nothing" do
    create_history(1)

    get pathology_requests_requests_path,
        params: { q: { created_on_eq: "16-01-2026" } }

    expect_empty_history
  end

  ["", "invalid", "0", "-1"].each do |page_number|
    it "treats page #{page_number.inspect} as the first page" do
      records = create_history(2)

      get pathology_requests_requests_path, params: { page: page_number, per_page: 1 }

      expect(response).to be_successful
      expect(history_links).to eq(pdf_paths(records.first(1)))
    end
  end

  it "renders an empty page when the page number exceeds the last page" do
    create_history(2)

    get pathology_requests_requests_path, params: { page: 3, per_page: 1 }

    expect_empty_history
  end

  %i(super_admin devops admin clinical read_only).each do |role|
    it "allows a #{role} user to view the history" do
      records = create_history(1)
      login_as(create(:user, role:))

      get pathology_requests_requests_path

      expect(response).to be_successful
      expect(history_links).to eq(pdf_paths(records))
    end
  end

  it "redirects signed-out users to sign in without exposing request rows" do
    create_history(1)
    logout

    get pathology_requests_requests_path

    expect(response).to redirect_to(new_user_session_path)
    expect(history_links).to be_empty
  end

  it "denies a signed-in user without any role" do
    create_history(1)
    user = create(:user, role: nil, prescriber: false)
    user.roles.clear
    expect(user.roles).to be_empty
    login_as(user)

    get pathology_requests_requests_path

    expect(response).to redirect_to(dashboard_path)
    expect(history_links).to be_empty
  end

  def create_history(count, at: printed_at)
    Array.new(count) do |index|
      create(
        :pathology_requests_request,
        patient:,
        clinic:,
        consultant:,
        created_at: at - index.minutes
      )
    end
  end

  def pdf_paths(records)
    records.map { |record| pathology_requests_request_path(id: record.id, format: "pdf") }
  end

  def history_links
    response.parsed_body.css("table#requests tbody tr td:first-child a").pluck("href")
  end

  def expect_empty_history
    expect(response).to be_successful
    expect(response.body).to include("No requests forms have been printed yet.")
    expect(history_links).to be_empty
    expect(response.parsed_body.css('a[rel="next"]')).to be_empty
  end
end
