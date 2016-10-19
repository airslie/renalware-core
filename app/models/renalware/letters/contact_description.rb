require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactDescription < ActiveRecord::Base
      validates :system_code, presence: true, uniqueness: true
      validates :name, presence: true, uniqueness: true
    end
  end
end
