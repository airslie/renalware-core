require "virtus"

class DropdownButtonItem < ActionView::Base
  include ActionView::Helpers::TagHelper
  include Virtus.model(mass_assignment: false)

  attribute :title, String
  attribute :url, String
  attribute :icon, String
  attribute :url_options, Hash
  attribute :enabled, Boolean

  def initialize(**options)
    @title = options.delete(:title)
    @url = options.delete(:url)
    @icon = options.delete(:icon)
    @url_options = options
    @enabled = options.delete(:enabled) || true
  end

  def to_html
    enabled? ? enabled_html : disabled_html
  end

  private

  def enabled_html
    content_tag(:li) do
      capture do
        link_to(url, url_options) do
          concat(icon_html)
          concat(title) if title.present?
        end
      end
    end
  end

  def disabled_html
    content_tag(:li, class: "disabled") do
      concat(icon_html)
      concat(title) if title.present?
    end
  end

  # rubocop:disable Rails/OutputSafety
  def icon_html
    return if icon.blank?
    "<i class='fa fa-link-annotation #{icon}'></i>".html_safe
  end
  # rubocop:enable Rails/OutputSafety
end
