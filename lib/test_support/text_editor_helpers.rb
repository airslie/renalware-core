module TextEditorHelpers
  # Basecamp trix uses hidden input to populate its editor
  def fill_in_trix_editor(id, value)
    # p find(:xpath, "//*[@id='#{id}']", visible: false)
    find(:xpath, "//*[@id='#{id}']", visible: false).set(value)
  end
end
