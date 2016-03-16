class SmartDelegator
  def initialize(object)
    @object = object
  end

  def respond_to?(method, include_private = false)
    super || @object.respond_to?(method, include_private)
  end

  def inspect
    "SmartDelegator(#{@object.inspect})"
  end

  def method_missing(method, *args, &block)
    value = @object.public_send(method, *args, &block)
    if value.class == @object.class
      self.class.new(value)
    else
      value
    end
  end
end