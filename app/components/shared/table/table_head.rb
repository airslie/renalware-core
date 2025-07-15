# frozen_string_literal: true

class Shared::TableHead < Shared::Base
  def view_template(&)
    th(**attrs, &)
  end
end
