# frozen_string_literal: true

# This is basic implementation of a Rails form as a Phlex component.
# Consider this an experiment. We'll look into other solutions such Flexi::Form.

class Shared::Form < Shared::Base
  register_value_helper :form_authenticity_token

  def initialize(model, **attrs)
    @model = model
    @return_to = attrs.delete(:return_to)
    super(**attrs)
  end

  def view_template
    form(**mix({ class: "fn-form", action:, method: }, attrs)) do
      input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
      input(type: "hidden", name: "return_to", value: return_to)
      yield
      div(class: "form-actions") do
        cancel_button
        submit_button
      end
    end
  end

  def cancel_button
    Button(type: :link, href: return_to, class: "mr-3") { "Cancel" }
  end

  def submit_button
    Button(value: method == :post ? "Create" : "Save")
  end

  def action
    polymorphic_path([model.patient, model])
  end

  def method
    model.persisted? ? :patch : :post
  end

  private

  attr_reader :model, :url, :return_to

  def default_attrs
    {
      class: "flex flex-col gap-4",
      novalidate: true,
      accept_charset: "UTF-8"
    }
  end
end
