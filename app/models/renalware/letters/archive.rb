require_dependency "renalware/letters"

module Renalware
  module Letters
    class Archive < ApplicationRecord
      include Accountable

      belongs_to :letter

      validates :content, presence: true
    end
  end
end
