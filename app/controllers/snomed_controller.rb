class SnomedController < ApplicationController

  def index
    render :json => Snomed.lookup(params[:snomed_term])
  end

end
