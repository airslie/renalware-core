module Renalware
  class PrdCode < ActiveRecord::Base

    has_many :esrf_info

  end
end