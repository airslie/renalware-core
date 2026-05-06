module Renalware
  module Renal
    class SafetyAlertPolicy < BasePolicy
      alias historical? index?
      alias resolve? update?
    end
  end
end
