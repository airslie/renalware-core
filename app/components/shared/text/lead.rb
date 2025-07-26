# frozen_string_literal: true

class Shared::Lead < Shared::Base
  def view_template(&)
    span(**attrs, &)
  end

  private

  def default_attrs
    {}
  end
end
