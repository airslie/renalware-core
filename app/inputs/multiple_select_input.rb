class MultipleSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input_type
    :multiple_select
  end

  def input_html_options
    options = super
    klass = (options[:class] ||= [])
    klass << "chosen-select"
    options[:multiple] = "multiple"
    options
  end
end
