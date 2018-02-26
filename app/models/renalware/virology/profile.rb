require_dependency "renalware/virology"

module Renalware
  module Virology
    class Profile < ApplicationRecord
      belongs_to :patient, touch: true
    end
  end
end
