require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      belongs_to :letter
      belongs_to :address

      validates :name, presence: true
      validates :address, presence: true
    end
  end
end
