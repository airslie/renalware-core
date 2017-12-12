require_dependency "renalware"

# Mix this module into a Patient Query object for example in order to include the patient's
# current key pathology and enable sorting on pathology date and value fields using
# ransack's sort_link helper in the view.
#
module Renalware
  module PatientPathologyScopes
    def with_current_pathology
      includes(:current_observation_set)
    end

    # Define some ransackers to make it easier to sort the table (using sort_link)
    # on pathology dates and values. Note it wasn't possible just to use say
    # = sort_link(.., "pathology_current_key_observation_sets.cre_observed_at", ..)
    # or
    # = sort_link(.., :pathology_current_key_observation_set_cre_observed_at", ..)
    # as ransack wasn't happy and discarded the sort predicate.
    # So here we mix in useful ransackers as short cut to use in sort_link
    #
    # Example usage:
    #   = sort_link(<url>, :cre_observed_at, "CRE date")
    #
    def self.extended(base)
      %i(hgb ure cre).each do |code|
        base.ransacker(code) { pathology_result_sort_predicate(code) }
        base.ransacker(:"#{code}_date") { pathology_date_sort_predicate(code) }
      end

      %i(mdrd).each do |code|
        base.ransacker(code) { pathology_result_sort_predicate(code) }
      end
    end

    def self.pathology_result_sort_predicate(column)
      Arel.sql(
        "cast(values -> '#{column.upcase}' ->> 'result' as float)"
      )
    end

    def self.pathology_date_sort_predicate(column)
      Arel.sql(
        "cast(values -> '#{column.upcase}' ->> 'observed_at' as date)"
      )
    end
  end
end
