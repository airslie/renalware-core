require 'rails_helper'

module Renalware
  RSpec.describe EsrfInfo, :type => :model do
    it { should belong_to :patient }
  end
end