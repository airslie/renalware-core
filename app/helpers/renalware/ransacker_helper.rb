module Renalware
  module RansackerHelper
    # Provides a more forgiving implementation for sort links. If no query
    # is provided then it just returns the label. Helpful if a partial is
    # used in multiple places where sortable links are not always required.
    #
    def sort_link(query, attribute, label, *args)
      if query.present?
        super(query, attribute, label, *args)
      else
        label
      end
    end
  end
end

