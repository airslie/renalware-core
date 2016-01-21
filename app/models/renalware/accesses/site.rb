module Renalware
  module Accesses
    class Site < ActiveRecord::Base
      validates :code, presence: true
      validates :name, presence: true
    end
  end
end
