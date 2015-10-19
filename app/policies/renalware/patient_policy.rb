module Renalware
  class PatientPolicy < BasePolicy
    def death_update? ; has_write_privileges? end
    def death? ; has_write_privileges? end
  end
end
