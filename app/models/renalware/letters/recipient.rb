require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      belongs_to :letter
      has_one :address, as: :addressable
      belongs_to :source, polymorphic: true

      accepts_nested_attributes_for :address
    end
  end
end
