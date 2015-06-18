class RenalwareController < ApplicationController
  # Cancancan authorization filter
  load_and_authorize_resource
end
