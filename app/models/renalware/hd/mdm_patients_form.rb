# frozen_string_literal: true

module Renalware
  module HD
    class MDMPatientsForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :hospital_unit_id, Integer
      attribute :schedule

      def options
        opts = {
          hospital_unit_id_eq: hospital_unit_id
        }
        if schedule.to_i > 0
          opts[:schedule_defnition_id_eq] = schedule.to_i
        else
          case schedule
          when "any_mtw" then opts[:schedule_defnition_id_eq] = [1, 2, 3]
          end
        end
        opts
      end
    end
  end
end
