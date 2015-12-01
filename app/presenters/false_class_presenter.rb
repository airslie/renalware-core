class FalseClassPresenter < SimpleDelegator
  def to_s
    I18n.t :false
  end
end
