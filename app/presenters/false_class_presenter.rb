class FalseClassPresenter < SimpleDelegator
  def to_s
    # rubocop:disable-next Lint/BooleanSymbol
    I18n.t :false
  end
end
