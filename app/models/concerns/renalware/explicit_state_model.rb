module Renalware
  # Enables Explicit State Models with ActiveRecord in contrast to the State pattern or
  # Finite State Machines (FSM). For more information:
  # https://medium.com/@martinezdelariva/explicit-state-modeling-f6e534c33508#.ljvhnkz01
  #
  # Example
  #   class Letter < ActiveRecord
  #     include ExplicitStateModel
  #     # define the states you would like
  #     has_states :draft, :archived
  #   end
  #
  # Calling the `has_states` macro will:
  # - define scopes for each state; e.g. `Letter.draft`, `Letter.archived`
  # - add a state attribute; e.g. `Letter::Draft.state # => "draft"`
  #
  # Create subclasses representing those states, this uses ActiveRecord's STI
  # implementation.
  #
  #   class Letter::Draft < Letter
  #     def archive!
  #       becomes!(Archived)
  #     end
  #   end
  #
  #   class Letter::Archived < Letter
  #   end
  #
  # You are responsible for managing state transitions using ActiveRecord's
  # `becomes` class method:
  #
  #   Letter::Draft.create!
  #   draft_letter = Letter.draft.first!
  #   draft_letter.state # => "draft"
  #   archived_letter = draft_letter.archive!
  #   archived_letter.save!
  #   archived_letter.state # => "archived"
  #
  module ExplicitStateModel
    extend ActiveSupport::Concern

    included do
      # Adds a `state` attribute; e.g. `Letter::Draft.state # => "Draft"`
      #
      def state
        self.class.name.demodulize.downcase
      end
    end

    module ClassMethods
      # Adds a ActiveRecord scopes for each state defined; e.g. `Letter.draft`
      #
      def has_states(*states)
        states.each { |state| state_scope(state, state)}
      end

      # Allows for custom scope names, example:
      #
      #   class Letter
      #     has_states :draft, :archived
      #     state_scope :reviewable, :draft
      #   end
      #
      #   Letter.reviewable # => returns draft letters
      #
      def state_scope(name, state)
        instance_eval do
          scope name, -> { where(type: state_class_name(state)) }
        end
      end

      def state_class_name(name)
        const_get(name.to_s.classify)
      end
    end
  end
end
