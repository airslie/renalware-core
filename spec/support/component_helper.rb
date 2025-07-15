module ComponentHelper
  # Nokogiri won't correctly parse table rows and cells without a surrounding
  # table tag. You can do some basic text include checks but if you want to use
  # css(".some_class") then use this method.
  def table_fragment
    @table_fragment ||= Nokogiri::HTML5.fragment("<table>#{response}</table>")
  end

  # When you have an HTML fragment that is not a complete valid HTML document
  # with surrounding <html> tags, use this.
  def fragment
    @fragment ||= Nokogiri::HTML5.fragment(response)
  end

  # This is what you want when rendering complete views. We don't have these but
  # components that inherit from Views::Base and are named after controller
  # actions (e.g. class Articles::Index < Views::Base).
  def document
    @document ||= Nokogiri::HTML5(response)
  end

  # Grab a TestController so that the component can be rendered using the Rails
  # view context which is needed to be able to render URLs.
  # This method is also handy if you want to check the actual HTML string
  # returned without going through Nokogiri.
  def response
    @response ||= controller.view_context.render subject
  end

  def controller
    @controller ||= ActionView::TestCase::TestController.new
  end
end
