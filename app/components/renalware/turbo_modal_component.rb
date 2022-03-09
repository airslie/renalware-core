# frozen_string_literal: true

module Renalware
  class TurboModalComponent < ApplicationComponent
    include Turbo::FramesHelper
    rattr_initialize [:title]
  end
end
