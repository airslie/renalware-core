# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class Consultant < ActiveType::Record[Renalware::User]
    end
  end
end
