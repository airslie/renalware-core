# frozen_string_literal: true

module Renalware
  module Dietetics
    class MDMPresenter < Renalware::MDMPresenter
      def pathology_code_group_name
        :dietetics_mdm
      end
    end
  end
end
