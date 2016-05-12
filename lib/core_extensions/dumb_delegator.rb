class DumbDelegator < ::BasicObject
  # Handle public_send correctly when ActionView calls this method
  # Reference: https://github.com/stevenharman/dumb_delegator/issues/9
  #
  def public_send(method, *args, &block)
    if respond_to?(method)
      __send__(method, *args, &block)
    else
      __getobj__.public_send(method, *args, &block)
    end
  end

  def try(*a, &b)
    raise "Cannot call #try on a BasicObject"
  end

  def try!(*a, &b)
    raise "Cannot call #try! on a BasicObject"
  end

  def send(method_name, *args, &block)
    __send__(method_name, *args, &block)
  end

  def inspect
    "DumbDelegator(#{__getobj__.inspect})"
  end
end
