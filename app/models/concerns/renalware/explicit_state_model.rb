module Renalware
  module ExplicitStateModel
    extend ActiveSupport::Concern

    included do
      def state
        self.class.name.demodulize.downcase
      end
    end

    module ClassMethods
      def has_states(*states)
        self.class.instance_eval do
          define_method :states do
            states.map(&:to_s)
          end
        end

        states.each { |state| state_scope(state, state)}
      end

      def state_scope(name, state)
        instance_eval do
          scope name, -> { where(type: state_class_name(state)) }
        end
      end

      private

      def state_class_name(name)
        const_get(name.to_s.classify)
      end
    end
  end
end
