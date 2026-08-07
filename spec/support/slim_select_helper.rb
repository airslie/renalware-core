module SlimSelectHelper
  def slim_select(item_text, options)
    # Find the correct dropdown at the bottom of the page
    expect(page).to have_field(options[:from], visible: :all)
    select_box = find_field(options[:from], visible: :all)
    data_id = select_box["data-id"]

    return if selected_value?(data_id, item_text, options[:multi])

    open_select(data_id)
    search_and_select(data_id, item_text)

    # Ensure item has been selected before moving on
    within(".ss-main[data-id='#{data_id}']") do
      expect(page).to have_css(selected_css(options[:multi]), text: item_text)
    end

    unless options[:multi]
      expect(page).to have_no_css(".ss-content[data-id='#{data_id}']", visible: :visible)
    end
  end

  private

  def open_select(data_id)
    find(".ss-main[data-id='#{data_id}']").click
  end

  def search_and_select(data_id, item_text)
    # Search globally in case the caller is inside a within block.
    within(page.document.find(".ss-content[data-id='#{data_id}']")) do
      find(".ss-search input").set(search_term(item_text))
      wait_for_list item_text
      wait_and_click_on item_text
    end
  end

  def selected_css(multi)
    multi ? ".ss-value-text" : ".ss-single"
  end

  def selected_value?(data_id, item_text, multi)
    page.has_css?(
      ".ss-main[data-id='#{data_id}'] #{selected_css(multi)}",
      text: item_text,
      wait: 0.5
    )
  end

  def wait_and_click_on(item_text)
    within(".ss-list") do
      expect(page).to have_text(item_text)
      find(".ss-option", text: item_text).click
    end
  end

  # This gets around an issue with slim select not correctly highlighting
  # special regex characters (e.g. selecting drugs with a trade name in brackets).
  # This is done so that .ss-search-highlight always highlights the whole
  # item_text so that it's clickable. In real use, the user would just click on
  # the partially highlighted element so it's not a real issue.
  def search_term(item_text)
    item_text.gsub(/\(|\)/, ".")
  end

  # Wait for the list of items (or a message) to appear before continuing
  def wait_for_list(item_text)
    within(".ss-list") do
      expect(page).to have_no_css(".ss-searching")
      expect(page).to have_text(item_text)
    end
  end
end
