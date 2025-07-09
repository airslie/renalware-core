# frozen_string_literal: true

class Shared::DescriptionList < Shared::Base
  def view_template(&)
    dl(**attrs, &)
  end

  private

  def default_attrs
    { class: "dl-horizontal" }
  end
end
