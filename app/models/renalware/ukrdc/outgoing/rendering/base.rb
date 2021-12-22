# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Base
          def create_node(name, value = nil)
            elem = Ox::Element.new(name.to_s)
            elem << value.to_s if value.present?
            yield(elem) if block_given?
            elem
          end

          # Example output:
          #   "123 approx" => 123
          #   "123" => 123
          #   123 => 123
          #   123.1 => 123
          #   0 => nil
          #   "n/a" => nil
          def coerce_to_integer(value)
            return if value.blank? || value.to_i == 0

            value.to_i
          end

          # Example output:
          #   "123 approx" => 123.0
          #   "123" => 123.0
          #   123 => 123.0
          #   123.1 => 123.1
          #   0 => nil
          #   "n/a" => nil
          def coerce_to_float(value)
            return if value.blank? || value.to_f == 0.0

            value.to_f
          end
        end
      end
    end
  end
end
