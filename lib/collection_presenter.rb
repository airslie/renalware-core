class CollectionPresenter
  def initialize(original_collection, presenter_class = nil, &block)
    @original_collection = original_collection

    @decorated_collection ||= Enumerator.new do |yielder|
      original_collection.each do |element|
        presenter = block_given? ? yield(element) : presenter_class.new(element)
        yielder.yield(presenter)
      end
    end
  end

  def to_ary
    @decorated_collection.to_a
  end

  def to_a
    @decorated_collection
  end

  def method_missing(method, *args, &block)
    if @decorated_collection.respond_to?(method)
      @decorated_collection.public_send(method, *args, &block)
    else
      @original_collection.public_send(method, *args, &block)
    end
  end

  def respond_to?(method)
    @decorated_collection.respond_to?(method) || @original_collection.respond_to?(method)
  end
end