# This class delegates method calls to the given object.
# If the returned value if an instance of the delegated object,
# the smart delegator will return an instance of itself.
class SmartDelegator

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def respond_to?(method, include_private = false)
    super || object.respond_to?(method, include_private)
  end

  def inspect
    "SmartDelegator(#{object.inspect})"
  end

  def method_missing(method, *args, &block)
    returned_object = object.public_send(method, *args, &block)
    if returned_object.class == object.class
      self.class.new(returned_object)
    else
      returned_object
    end
  end
end