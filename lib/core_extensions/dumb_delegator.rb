# frozen_string_literal: true

# Used in app/models/renalware/ukrdc/outgoing/rendering/clinic_visit_observation.rb:11
class DumbDelegator < BasicObject
  # Handle public_send correctly when ActionView calls this method
  # Reference: https://github.com/stevenharman/dumb_delegator/issues/9
  #
  def public_send(method, *, &block)
    if respond_to?(method)
      __send__(method, *, &block)
    else
      __getobj__.public_send(method, *, &block)
    end
  end

  def try(*_a, &_b)
    raise "Cannot call #try on a BasicObject"
  end

  def try!(*_a, &_b)
    raise "Cannot call #try! on a BasicObject"
  end

  def send(method_name, *, &block)
    __send__(method_name, *, &block)
  end

  def inspect
    "DumbDelegator(#{__getobj__.inspect})"
  end
end
