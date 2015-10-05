module Renalware
  class PrdCode < ActiveRecord::Base
    def to_s
      term
    end
  end
end
