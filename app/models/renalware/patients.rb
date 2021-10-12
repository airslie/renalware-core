# frozen_string_literal: true

require_dependency "renalware/pathology"
require_dependency "renalware/feeds"

module Renalware
  module Patients
    module_function

    def table_name_prefix
      "patient_"
    end

    def configure; end

    def self.cast_user(user)
      ActiveType.cast(user, ::Renalware::Patients::User)
    end
  end
end
