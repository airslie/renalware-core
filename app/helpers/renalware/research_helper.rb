# frozen_string_literal: true

module Renalware
  module ResearchHelper
    # Given an STI class name like "Renalware::Heroic::Research::Study" we extract the
    # namespace so we can build derive the partial path for a type like :participaton, e.g.
    # "Renalware::Heroic::Research::Participation"
    #
    # Example usage:
    # path_to_research_document_form_partial(
    #   "Renalware::Heroic::Research::Study",
    #   :participation
    # )
    def path_to_research_document_form_partial(study_class, type = nil)
      return if study_class.blank?

      partial_path = "#{study_class.deconstantize.underscore}/#{type}/form"
      partial_path&.gsub("::", "/")&.gsub("//", "/")&.gsub("//", "/")
    end
  end
end
