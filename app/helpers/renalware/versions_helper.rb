# require 'medication_route'

module Renalware
  module VersionsHelper
    def who_did_it(model)
      if model.whodunnit
        user_id = model.whodunnit.to_i
        user = User.find(user_id)
        user.try(:name)
      else
        "System"
      end
    end
  end
end