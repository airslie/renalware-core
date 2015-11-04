module Renalware
  module Transplants
    class RegistrationVersion < PaperTrail::Version
      self.table_name = :transplants_registration_versions
    end
  end
end
