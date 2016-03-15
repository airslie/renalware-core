class SmartDelegator
  def initialize(object)
    @object = object
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