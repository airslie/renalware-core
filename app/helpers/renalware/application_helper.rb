require "inline_image"
require "git_commit_sha"
require "breadcrumb"

module Renalware
  module ApplicationHelper
    include Renalware::Engine.routes.url_helpers

    def default_patient_link(patient)
      link_to(patient, patient_clinical_summary_path(patient))
    end

    def patient_search
      ::Renalware::Patients::PatientSearch.call(params)
    end

    # For use in layouts
    def page_title(separator = Renalware.config.page_title_spearator)
      [
        content_for(:page_title),
        Renalware.config.site_name
      ].compact.join(separator)
    end

    def breadcrumb_for(title, url)
      Breadcrumb.new(title: title, anchor: link_to(title, url))
    end

    def flash_messages
      flash.to_hash.reject{ |key| key.to_sym == :timedout }
    end

    # For use in pages
    def page_heading(title)
      content_for(:page_title){ title.html_safe }
    end

    def t?(key)
      t(key, cascade: false, raise: false, default: "").present?
    end

    def back_link_to(text, path)
      capture do
        link_to(path) do
          concat "<i class='fa fa-arrow-left'></i>&nbsp;".html_safe
          concat text
        end
      end
    end

    def errors_css_class(model, attr)
      " field_with_errors" if model.errors.key?(attr)
    end

    def yes_no(bool)
      bool ? "Yes" : "No"
    end

    def default_for_associated(assoc, method, msg)
      assoc.present? ? assoc.public_send(method) : msg
    end

    def default_for_blank(val, msg)
      val.blank? ? msg : val
    end

    def default_for_blank_date(date, msg)
      date.blank? ? msg : l(date)
    end

    def default_for_blank_units(val, unit, msg)
      val.blank? ? msg : "#{val} #{unit}"
    end

    def medication_and_route(med_route)
      if med_route.blank?
        "No medication prescribed"
      else
        other_route = "Route: Other (Please specify in notes)"
        safe_join(
          med_route.map do |m|
            route = if m.medication_route.name == other_route
                      m.medication_route.full_name
                    else
                      m.medication_route.name
                    end
            "<li>
                #{m.drug.name} - #{route}
            </li>".html_safe
          end
        )
      end
    end

    def organisms_and_sensitivities(infection_organisms)
      if infection_organisms.blank?
        "Unknown"
      else
        safe_join(
          infection_organisms.map do |io|
            "<li>#{io.organism_code.name} - #{io.sensitivity}</li>".html_safe
          end
        )
      end
    end

    def organisms(infection_organisms)
      if infection_organisms.blank?
        "Unknown"
      else
        safe_join(infection_organisms.map { |io| "<li>#{io.organism_code.name}</li>".html_safe })
      end
    end

    def pipe_separator
      "&nbsp;|&nbsp;".html_safe
    end

    def blank_separator
      "&nbsp;".html_safe
    end

    def inline_image_tag(file_path, options = {})
      image = inline_image(file_path)
      image_tag(image.src, options)
    end

    def inline_image(file_path)
      # InlineImage.new("/app/assets/images/#{file_path}")
      InlineImage.new(asset_path(file_path))
    end

    def modality_description_for(modality)
      if modality.blank? || modality.new_record?
        I18n.t("renalware.modalities.none")
      else
        modality.description.name
      end
    end

    def semantic_app_version
      "#{VERSION}+sha.#{GitCommitSha.current}"
    end
  end
end
