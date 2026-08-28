class TrueClassPresenter < SimpleDelegator
  def to_s
    # rubocop:disable-next Lint/BooleanSymbol
    I18n.t :true
  end
end
