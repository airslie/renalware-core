# frozen_string_literal: true

require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class ConsultSite < ApplicationRecord
      validates :name, presence: true
    end
  end
end
