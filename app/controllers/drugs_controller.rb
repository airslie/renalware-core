class DrugsController < ApplicationController

  def new 
    @drug = Drug.new
  end

  def create
    @drug = Drug.new(allowed_params)
    if @drug.save
      redirect_to drugs_path, :notice => "You have successfully added a new drug."
    else
      render :new
    end
  end

  def index
    @drugs = Drug.all
  end

  def allowed_params
    params.require(:drug).permit(:name, :type, :deleted_at)
  end

end
