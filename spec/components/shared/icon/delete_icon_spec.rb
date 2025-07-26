# frozen_string_literal: true

RSpec.describe Shared::DeleteIcon do
  subject { described_class.new(path:, policy:) }

  let(:user) { create(:user, :super_admin) }
  let(:policy) { Renalware::BasePolicy.new(user, record) }
  let(:path) { "/patients/#{record.id}" }
  let(:record) { create(:patient) }
  let(:delete_svg) do
    <<~SVG.strip
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-5 w-5">
        <polyline points="3 6 5 6 21 6"></polyline>
        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
        <line x1="10" y1="11" x2="10" y2="17"></line>
        <line x1="14" y1="11" x2="14" y2="17"></line>
      </svg>
    SVG
  end

  it "renders component" do
    expect(policy.destroy?).to be(true)
    expect(fragment.css("a").attr("href").text).to eq(path)
    expect(response).to include(delete_svg)
  end
end
