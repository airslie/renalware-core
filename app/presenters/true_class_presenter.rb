class TrueClassPresenter < SimpleDelegator
  def to_s
    I18n.t :true
  end
end
