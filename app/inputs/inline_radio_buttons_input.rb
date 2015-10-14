class InlineRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def input_type
    "radio_buttons"
  end

  def input_options
    super.merge(item_wrapper_class: ["radio", ["radio", "inline"]])
  end
end