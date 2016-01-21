module Renalware
  module Accesses
    class Description < ActiveRecord::Base
      validates :code, presence: true
      validates :name, presence: true
    end
  end
end
