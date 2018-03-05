# frozen_string_literal: true

require "rails_helper"

describe Renalware::Transplants::DonorDashboardPresenter do
  subject { described_class.new(instance_double(Renalware::Patient)) }

  it { is_expected.to respond_to :patient }
  it { is_expected.to respond_to :donations }
  it { is_expected.to respond_to :donor_workup }
  it { is_expected.to respond_to :donor_operations }
  it { is_expected.to respond_to :donor_stages }
end
