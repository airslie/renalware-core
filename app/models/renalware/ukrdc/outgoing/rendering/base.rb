# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Base
          protected

          def create_node(name, value = nil)
            elem = Ox::Element.new(name.to_s)
            elem << value.to_s if value.present?
            yield(elem) if block_given?
            elem
          end
        end
      end
    end
  end
end
