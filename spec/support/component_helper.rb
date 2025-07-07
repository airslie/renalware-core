module ComponentHelper
  def fragment
    @fragment ||= Nokogiri::HTML5.fragment(subject.call)
  end

  def document
    @document ||= Nokogiri::HTML5(subject.call)
  end
end
