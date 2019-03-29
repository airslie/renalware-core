SimpleForm.setup do |config|
  def configure_label(b)
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :label_wrapper, tag: :div, class: "wrapper__label" do |ba|
      ba.use :label
    end
  end

  def configure_input(b)
    b.wrapper :right_input_wrapper, tag: :div, class: "wrapper__input" do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: :small, class: ["error"] }
      ba.use :hint,  wrap_with: { tag: :span, class: ["hint"] }
    end
  end

  # Configure various sized wrappers. We use CSS to style the label and inputs within the top div
  # with classes of e.g. "row wrapper-medium"
  %i(tiny small medium large).each do |size|
    config.wrappers(
      :"hz_#{size}", # eg hz_medium
      tag: "div",
      class: "row wrapper wrapper_style_horizontal wrapper_size_#{size}",
      hint_class: :field_with_hint,
      error_class: :error
    ) do |b|
      configure_label(b)
      configure_input(b)
    end
  end

  config.wrappers(
    :hz_datepicker,
    tag: :div,
    class: "row wrapper wrapper_style_horizontal wrapper_size_datepicker",
    hint_class: :field_with_hint,
    error_class: :error
  ) do |b|

    configure_label(b)

    b.wrapper :right_input_wrapper, tag: :div, class: "wrapper__input" do |ba|
      ba.wrapper :x, tag: :div, class: "row collapse datepicker-wrapper" do |bc|
        bc.use :prefix_column
        bc.use :input_column
        bc.use :error, wrap_with: { tag: :small, class: [:error, :datepicker_error] }
        bc.use :hint,  wrap_with: { tag: :span, class: :hint }
      end
    end
  end
end
