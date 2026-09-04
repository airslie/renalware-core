module Renalware::Clinics
  describe ClinicVisitPresenter do
    describe "#sanitized_notes" do
      it "removes blackisted tags but leaves whitelisted tags" do
        blackist = %w(b h1 i pre blockquote script).freeze
        whitelist = %w(p ul ol li span div strong em).freeze

        html = blackist.map { |tag| "<#{tag}>#{tag.upcase}</#{tag}>" }
        html.append whitelist.map { |tag| "<#{tag}>#{tag.upcase}</#{tag}>" }
        html.append "<br>"

        visit = ClinicVisit.new(notes: html.join(" "))
        presenter = described_class.new(visit)

        expected_html = blackist.map(&:upcase)
        expected_html.append whitelist.map { |tag| "<#{tag}>#{tag.upcase}</#{tag}>" }
        expected_html.append "<br>"

        expect(presenter.sanitized_notes).to eq(expected_html.join(" "))
      end
    end

    describe "#height" do
      it do
        visit = ClinicVisit.new(height: 1.2)
        presenter = described_class.new(visit)

        expect(presenter.height).to eq(1.2)
      end
    end

    describe "#height_in_cm" do
      subject { described_class.new(ClinicVisit.new(height:)).height_in_cm }

      [
        [1.2, 120],
        [nil, nil],
        [0, 0],
        [2, 200]
      ].each do |height, expected_height_in_cm|
        context "when a height is #{height}" do
          let(:height) { height }

          it { is_expected.to eq(expected_height_in_cm) }
        end
      end
    end

    describe "#heidi_state" do
      it "returns the latest Heidi session status" do
        visit = create(:clinic_visit)
        create(:heidi_session, clinic_visit: visit, status: :launched, created_at: 2.days.ago)
        create(:heidi_session, clinic_visit: visit, status: :synced, created_at: 1.day.ago)

        presenter = described_class.new(visit)

        expect(presenter.heidi_state).to eq("Synced")
      end

      it "is blank when there is no Heidi session" do
        presenter = described_class.new(ClinicVisit.new)

        expect(presenter.heidi_state).to be_nil
      end
    end

    describe "#heidi_status" do
      it "returns the latest Heidi session status value" do
        visit = create(:clinic_visit)
        create(:heidi_session, clinic_visit: visit, status: :launched, created_at: 2.days.ago)
        create(:heidi_session, clinic_visit: visit, status: :synced, created_at: 1.day.ago)

        presenter = described_class.new(visit)

        expect(presenter.heidi_status).to eq("synced")
      end
    end

    describe "#heidi_state_css_class" do
      it "returns a state-specific CSS class" do
        visit = create(:clinic_visit)
        create(:heidi_session, clinic_visit: visit, status: :sync_failed)

        presenter = described_class.new(visit)

        expect(presenter.heidi_state_css_class).to eq("heidi-state--sync-failed")
      end
    end
  end
end
