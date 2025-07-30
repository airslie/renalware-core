# frozen_string_literal: true

class Shared::ErrorMessage < Shared::Base
  def initialize(model, attribute)
    @model = model
    @attribute = attribute
    super()
  end

  def view_template
    div(class: "text-red-600") { text }
  end

  private

  attr_reader :model, :attribute

  def text
    model.errors.full_messages_for(attribute).first
  end
end
