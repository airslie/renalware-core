require_dependency "renalware/letters"

module Renalware
  module Letters
    class Description < ActiveRecord::Base
      validates_presence_of :text

      has_many :letters
    end
  end
end