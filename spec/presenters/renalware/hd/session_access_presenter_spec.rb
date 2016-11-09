require "rails_helper"

describe Renalware::HD::SessionAccessPresenter do
  subject(:presenter) { Renalware::HD::SessionAccessPresenter }

  def mock_session(access_type: "ABC",
                   access_type_abbreviation: "A",
                   access_site: "Site123456789123456789",
                   access_side: "right")
    double("Session",
      document: double(
        info: double(
          access_type: access_type,
          access_type_abbreviation: access_type_abbreviation,
          access_site: access_site,
          access_side: access_side
          )
        )
      )
  end

  describe "#to_s" do
    it "handles a nil session" do
      expect(presenter.new(nil).to_s).to eq("")
    end

    it "handles a nil session.document" do
      session = double("Session", document: nil)
      expect(presenter.new(session).to_s).to eq("")
    end

    it "returns only the access_type is that's all there is" do
      session = mock_session(access_site: nil, access_side: nil)
      expect(presenter.new(session).to_s).to eq("ABC")
    end

    it "returns only the access_site is that's all there is" do
      session = mock_session(access_type: nil, access_side: nil)
      expect(presenter.new(session).to_s).to eq("Site123456789123456789")
    end

    it "returns only the access_side is that's all there is" do
      session = mock_session(access_type: nil, access_site: nil)
      expect(presenter.new(session).to_s).to eq("Right")
    end

    it "concatenates all access fields if present" do
      expect(presenter.new(mock_session).to_s).to eq("ABC<br/>Site123456789123456789<br/>Right")
    end
  end

  describe "#to_html" do
    it "handles a nil session" do
      expect(presenter.new(nil).to_html).to eq("")
    end

    it "handles a nil session.document" do
      session = double("Session", document: nil)
      expect(presenter.new(session).to_html).to eq("")
    end

    it "uses the abbreviated access_type" do
      session = mock_session(access_site: nil, access_side: nil)
      expect(presenter.new(session).to_html).to eq("A")
    end

    it "truncates the access_site" do
      session = mock_session(access_type_abbreviation: nil, access_side: nil)
      expect(presenter.new(session).to_html).to eq("Site1&hellip;")
    end

    it "concatenates all access fields if present" do
      expect(presenter.new(mock_session).to_html).to eq("A/Site1&hellip;/R")
    end
  end
end
