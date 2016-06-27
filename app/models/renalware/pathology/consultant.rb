require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Consultant < ActiveType::Record[Renalware::User]

    end
  end
end
