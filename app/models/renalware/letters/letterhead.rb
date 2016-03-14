require_dependency "renalware/letters"

module Renalware
  module Letters
    class Letterhead < ActiveRecord::Base
      validates :name, presence: true
      validates :unit_info, presence: true
      validates :trust_name, presence: true
      validates :trust_caption, presence: true
    end
  end
end
