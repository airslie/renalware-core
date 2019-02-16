# frozen_string_literal: true

require "inline_image"
require "git_commit_sha"
require "breadcrumb"

module Renalware
  module ApplicationHelper
    include Renalware::Engine.routes.url_helpers
    include Pagy::Frontend

    def default_patient_link(patient)
      link_to(patient.to_s(:default), patient_clinical_summary_path(patient))
    end

    def default_patient_link_with_nhs_number(patient)
      link_to(patient&.to_s(:long), patient_clinical_summary_path(patient))
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
      flash.to_hash.reject { |key| key.to_sym == :timedout }
    end

    def warning_and_error_flash_messages
      flash.to_hash.reject { |key| %i(timedout notice success).include?(key.to_sym) }
    end

    def success_flash_messages
      flash.to_hash.select { |key| %i(notice success).include?(key.to_sym) }
    end

    # For use in pages
    # rubocop:disable Rails/OutputSafety
    def page_heading(title)
      content_for(:page_title) { title.html_safe }
    end
    # rubocop:enable Rails/OutputSafety

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

    def yes_no_if_set(bool)
      return if bool.nil?

      yes_no(bool)
    end

    def default_for_associated(assoc, method, msg)
      assoc.present? ? assoc.public_send(method) : msg
    end

    def default_for_blank(val, msg)
      val.presence || msg
    end

    def default_for_blank_date(date, msg)
      date.blank? ? msg : l(date)
    end

    def default_for_blank_units(val, unit, msg)
      val.blank? ? msg : "#{val} #{unit}"
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
      "#{Renalware::VERSION}+sha.#{GitCommitSha.current}"
    end

    # Shows a toastr alert which fades away after a period of time.
    # To position the toastr notification you could add this before the toastr call
    #   toastr.options.positionClass = 'toast-top-full-width';
    def toastr_flash_messages
      messages = []
      success_flash_messages.each do |type, message|
        type = "success" if type == "notice"
        type = "error"   if type == "alert"
        type = "warning" if type == "warning"
        text = "<script>$(function() { toastr.#{type}('#{message}') });</script>"
        messages << text.html_safe if message
      end
      messages.join("\n").html_safe if messages.any?
      # returns nil if no success messages
    end
  end
end
