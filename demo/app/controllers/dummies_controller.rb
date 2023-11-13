# frozen_string_literal: true

class DummiesController < ApplicationController
  def index
    render text: "OK?"
  end
end
