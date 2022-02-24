# frozen_string_literal: true

module SlimSelectHelper
  # Capybara helper for selecting an option in a sliem-select dropdown.
  # Assumption is that you have a label who's parent also contains the select list you
  # are choosing from.
  # Usage:
  #   js_select 'Item name', from: 'Label text
  #
  # src: https://gist.github.com/rickychilcott/caa06e2f1653f06cb3316875e6c60dc8
  # rubocop:disable Metrics/MethodLength
  def slim_select(item_text, options)
    from = options.fetch(:from)

    if from.exclude?("#")
      label = find("label", text: from)
      from = "##{label['for']}"
    end

    select_field = find(from, visible: false, wait: 2)
    slim_select_id = select_field["data-ssid"]
    slim_select_container = find("div.#{slim_select_id}")

    within(slim_select_container) do
      find(".ss-arrow, .ss-add").click
      sleep(0.5)
      input = find(".ss-search input").native
      input.send_keys(item_text)
      # find("div.ss-list").click => this did not work in cucumber specs
      find("div.ss-option").click
    end
  end
  # rubocop:enable Metrics/MethodLength
end
