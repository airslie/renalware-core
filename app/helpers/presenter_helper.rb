require_dependency "collection_presenter"

module PresenterHelper
  def present(object, presenter_class=nil, &block)
    if object.respond_to?(:each)
      CollectionPresenter.new(object, presenter_class, &block)
    else
      presenter_class.new(object)
    end
  end
end
