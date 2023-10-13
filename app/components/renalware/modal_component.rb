# frozen_string_literal: true

module Renalware
  class ModalComponent < ApplicationComponent
    include Turbo::FramesHelper
    attr_reader :remote, :title

    # renders_one :body
    # renders_one :trigger
    # renders_one :bottom_buttons_nav

    def initialize(remote: false, title: nil)
      @remote = remote
      @title = title

      super
    end

    def trigger_attributes
      { action: "click->modal#open" }
    end
  end
end
