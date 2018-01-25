require "rails_helper"

describe Renalware::Transplants::RecipientDashboardPresenter do
  subject { described_class.new(instance_double(Renalware::Patient)) }

  it { is_expected.to respond_to :patient }
  it { is_expected.to respond_to :recipient_workup }
  it { is_expected.to respond_to :registration }
  it { is_expected.to respond_to :recipient_operations }
  it { is_expected.to respond_to :donations }
  it { is_expected.to respond_to :investigations }
end
