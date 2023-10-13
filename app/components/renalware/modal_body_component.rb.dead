# frozen_string_literal: true

module Renalware
  class ModalBodyComponent < ApplicationComponent
    include Turbo::FramesHelper

    def turbo_frame_id
      request.headers["Turbo-Frame"]
    end
  end
end
