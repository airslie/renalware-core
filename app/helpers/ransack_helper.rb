# frozen_string_literal: true

module RansackHelper
  def sort_link_if(condition, query, attribute, label, *args)
    if condition
      sort_link([:renalware, query], attribute, label, *args)
    else
      label
    end
  end
end
