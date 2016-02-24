require_dependency "collection_presenter"

module PresenterHelper
  def present(collection, presenter_class=nil, &block)
    CollectionPresenter.new(collection, presenter_class, &block)
  end
end
