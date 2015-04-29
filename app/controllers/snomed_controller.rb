class SnomedController < ApplicationController

  def index
    render :json => Snomed.search(params[:snomed_term]).to_h
  end

end
