module Renalware
  class DropdownButtonComponent < ApplicationComponent
    include IconHelper

    DEFAULT_BUTTON_CLASSES = "btn btn-secondary btn-compact btn-dropdown".freeze
    DEFAULT_ITEM_CLASSES = "text-gray-900 block px-4 py-2".freeze
    DEFAULT_MENU_CLASSES = "dropdown-drawer hidden".freeze
    DEFAULT_WRAPPER_CLASSES = "relative text-left".freeze
    DEFAULT_OPTIONS = {
      button_classes: DEFAULT_BUTTON_CLASSES,
      button_options: {},
      disclosure_icon: :"chevron-down",
      disclosure_icon_options: {},
      icon: nil,
      icon_options: {},
      item_classes: DEFAULT_ITEM_CLASSES,
      items: [],
      menu_classes: DEFAULT_MENU_CLASSES,
      menu_id: nil,
      menu_style: "z-index: 9999;",
      wrapper_classes: DEFAULT_WRAPPER_CLASSES
    }.freeze
    OPTION_ATTRIBUTES = %i(
      button_classes button_options disclosure_icon disclosure_icon_options icon icon_options
      item_classes items menu_classes menu_id menu_style wrapper_classes
    ).freeze

    class ItemComponent < ApplicationComponent
      include IconHelper

      DROPDOWN_TOGGLE_ACTION = "dropdown#toggle".freeze

      attr_reader :title, :url, :enabled, :icon, :icon_options, :item_classes, :link_options

      def initialize(title:, **options)
        super()

        @title = title
        @url = options.delete(:url)
        @enabled = options.delete(:enabled) { true }
        @icon = options.delete(:icon)
        @icon_options = options.delete(:icon_options) { {} }
        @item_classes = options.delete(:item_classes) { DEFAULT_ITEM_CLASSES }
        @link_options = with_dropdown_toggle_action(options.reverse_merge(class: item_classes))
      end

      def call
        return disabled_item unless enabled

        link_to(url, link_options) { item_content }
      end

      private

      def disabled_item
        tag.span(class: item_classes) { item_content }
      end

      def item_content
        return title if icon.blank?

        tag.div(class: "flex items-center") do
          concat inline_icon(icon, **icon_options)
          concat tag.span(class: "ml-2") { title }
        end
      end

      def with_dropdown_toggle_action(options)
        data = options.fetch(:data, {}).dup
        existing_action = data.delete(:action) || data.delete("action")
        actions = [DROPDOWN_TOGGLE_ACTION, existing_action].compact_blank.uniq
        data[:action] = actions.join(" ")
        options.merge(data:)
      end
    end

    renders_many :items, ItemComponent

    attr_reader :title, :icon, :static_items, :button_classes, :button_options, :disclosure_icon,
                :disclosure_icon_options, :icon_options, :item_classes, :menu_classes, :menu_id,
                :menu_style, :wrapper_classes

    def initialize(title:, **options)
      super()

      @title = title
      unknown_options = options.keys - OPTION_ATTRIBUTES
      raise ArgumentError, "Unknown options: #{unknown_options.to_sentence}" if unknown_options.any?

      component_options = DEFAULT_OPTIONS.merge(options)
      @static_items = component_options.delete(:items)

      component_options.each do |attribute, value|
        instance_variable_set("@#{attribute}", value)
      end

      @menu_id ||= "dropdown-button-#{object_id}"
    end

    def wrapper_options
      {
        class: wrapper_classes,
        data: { controller: "dropdown" }
      }
    end

    def merged_button_options
      {
        aria: { controls: menu_id, expanded: false },
        class: button_classes,
        data: { action: "dropdown#toggle click@window->dropdown#hide" },
        type: "button"
      }.deep_merge(button_options)
    end

    def menu_options
      {
        class: menu_classes,
        data: {
          dropdown_target: "menu",
          transition_enter_from: "opacity-0 scale-95",
          transition_enter_to: "opacity-100 scale-100",
          transition_leave_from: "opacity-100 scale-100",
          transition_leave_to: "opacity-0 scale-95"
        },
        id: menu_id,
        style: menu_style
      }
    end

    def item_link_options(item)
      with_dropdown_toggle_action(
        item.except(:enabled, :icon, :icon_options, :title, :url).reverse_merge(class: item_classes)
      )
    end

    def item_enabled?(item)
      item.fetch(:enabled, true)
    end

    def item_content(item)
      return item.fetch(:title) if item[:icon].blank?

      tag.div(class: "flex items-center") do
        concat inline_icon(item.fetch(:icon), **item.fetch(:icon_options, {}))
        concat tag.span(class: "ml-2") { item.fetch(:title) }
      end
    end

    def with_dropdown_toggle_action(options)
      data = options.fetch(:data, {}).dup
      existing_action = data.delete(:action) || data.delete("action")
      actions = [ItemComponent::DROPDOWN_TOGGLE_ACTION, existing_action].compact_blank.uniq
      data[:action] = actions.join(" ")
      options.merge(data:)
    end
  end
end
