# frozen_string_literal: true

require "document/embedded"
require "document/enum"

module Renalware
  module Virology
    class ProfileDocument < Document::Embedded
      attribute :hiv, YearDatedDiagnosis
      attribute :hepatitis_b, YearDatedDiagnosis
      attribute :hepatitis_c, YearDatedDiagnosis
    end
  end
end
