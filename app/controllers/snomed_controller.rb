class SnomedController < ApplicationController

  def index
    @results = Snomed.lookup("")
    respond_to do |format|
      format.html { redirect_to(problems_patient_url) }
      format.json { render :json => @results }
    end
  end

end
