class SnomedController < ApplicationController

  def index
    render :json => Snomed.search(snomed_params).to_h
  end

  private

  def snomed_params
    { 'query' => params[:snomed_term], 'semanticTag' => params[:semantic_tag] }
  end

end
