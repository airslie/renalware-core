module NewSlimSelectHelper
  # This is a replacement for SlimSelectHelper
  # Once all uses of slim_select have
  # been switched over to this one we can remove the old module
  # and rename this one.
  def slim_select(item_text, options)
    expect(page).to have_field(options[:from], visible: :all)
    select_box = find_field(options[:from], visible: :all)
    data_id = select_box["data-id"]

    # Click on the dropdown to show it
    find(".ss-main[data-id='#{data_id}'] .ss-arrow").click

    # Click on the appropriate item in the list
    within(".ss-content[data-id='#{data_id}']") do
      wait_for_list item_text, options[:wait_for]
      find(".ss-search input").set search_term(item_text)
      wait_and_click_on item_text
    end

    # Ensure drop down has disappeared before continuing
    expect(page).to have_no_css("div.ss-list")
  end

  private

  def wait_and_click_on(item_text)
    within(".ss-list") do
      expect(page).to have_content(item_text)
      find(".ss-search-highlight", text: item_text).click
    end
  end

  # This gets around an issue with slim select not correctly highlighting
  # special regex characters (e.g. selecting drugs with a trade name in brackets).
  # This is done so that .ss-search-highlight always highlights the whole
  # item_text so that it's clickable.
  def search_term(item_text)
    item_text.gsub(/\(|\)/, ".")
  end

  # Wait for the list of items (or a message) to appear before continuing
  def wait_for_list(item_text, text_to_wait_for)
    within(".ss-list") do
      expect(page).to have_content(text_to_wait_for || item_text)
    end
  end
end
