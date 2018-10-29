# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "DialysisSession" do
  helper(Renalware::ApplicationHelper)

  subject(:rendered) do
    render partial: partial, locals: { session: presenter, builder: builder }
  end

  let(:session) { Renalware::HD::Session::Closed.new(args) }
  let(:presenter) { Renalware::HD::SessionPresenter.new(session) }
  let(:partial) { "renalware/api/ukrdc/patients/procedures/dialysis_session.xml.builder" }
  let(:builder) { Builder::XmlMarkup.new }
  let(:args) {
    {
      performed_on: "2018-11-01",
      start_time: "11:00",
      end_time: "13:00"
    }
  }

  it "renders start and stop attributes" do
    args.merge!(
      start_time: "11:00",
      end_time: "13:00"
    )

    expect(rendered).to include("start=\"2018-11-01T11:00:00+00:00\"")
    expect(rendered).to include("stop=\"2018-11-01T13:00:00+00:00\"")
    expect(rendered).to include("<QHD19>Y</QHD19>")
    p rendered
  end

  describe "#QHD19 (Symptomatic hypotension)" do
    context "when had_intradialytic_hypotension is yes" do
      before { session.document.complications.had_intradialytic_hypotension = :yes }

      it { is_expected.to include("<QHD19>Y</QHD19>") }
    end

    context "when had_intradialytic_hypotension is no" do
      before { session.document.complications.had_intradialytic_hypotension = :no }

      it { is_expected.to include("<QHD19>N</QHD19>") }
    end

    context "when had_intradialytic_hypotension is nil" do
      before { session.document.complications.had_intradialytic_hypotension = nil }

      it { is_expected.to include("<QHD19>N</QHD19>") }
    end
  end

  describe "QHD30 (Blood Flow Rate)" do
    before { session.document.dialysis.blood_flow = "123" }

    it { is_expected.to include("<QHD30>123</QHD30>") }
  end

  describe "QHD31 (Time Dialysed in Minutes)" do
    before {
      session.start_time = "11:00"
      session.end_time = "13:01"
      session.compute_duration
    }

    it { is_expected.to include("<QHD31>121</QHD31>") }
  end

  describe "QHD32 (Sodium in Dialysate)" do
    before {
      dialysate = build_stubbed(:hd_dialysate, sodium_content: 13)
      session.dialysate = dialysate
    }

    it { is_expected.to include("<QHD32>13</QHD32>") }
  end

  describe "QHD20 (Vascular Access Used)" do
    before {
      session.document.info.access_type = "Tunnelled subclav"
      # rr02_code { "TLN" }
      # rr41_code { "LS" }
    }

    it { is_expected.to include("<QHD20>Tunnelled subclav</QHD20>") }
  end

  describe "QHD21 (Vascular Access Site) ??????" do
    before {
      session.document.info.access_side = :left
    }

    it { is_expected.to include("<QHD21>left</QHD21>") }
  end

  # TODO: Needling Method == hd_profile.cannualation type?
  # describe "QHD33 (Needling Method)" do
  #   before {
  #     patient.
  #   }

  #   it { is_expected.to include("<QHD21>left</QHD21>") }
  # end
end
