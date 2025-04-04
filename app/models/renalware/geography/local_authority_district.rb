# frozen_string_literal: true

module Renalware
  module Geography
    class LocalAuthorityDistrict < ApplicationRecord
      validates :name, presence: true
      validates :code, presence: true
    end
  end
end
