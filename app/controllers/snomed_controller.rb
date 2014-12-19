class SnomedController < ApplicationController
  
  def index
    @results = Snomed.lookup("cool beans")
    render nothing: true
  end

end
