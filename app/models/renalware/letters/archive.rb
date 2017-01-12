require_dependency "renalware/letters"

module Renalware
  module Letters
    class Archive < ApplicationRecord
      include Accountable

      belongs_to :letter

      validates_presence_of :content
    end
  end
end
