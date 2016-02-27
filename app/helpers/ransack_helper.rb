module RansackHelper
  def sort_link_if(condition, query, attribute, label, *args)
    if condition
      sort_link(query, attribute, label, *args)
    else
      label
    end
  end
end
