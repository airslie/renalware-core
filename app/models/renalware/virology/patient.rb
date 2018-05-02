# frozen_string_literal: true

require_dependency "renalware/virology"

module Renalware
  module Virology
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :profile, dependent: :destroy
    end
  end
end
