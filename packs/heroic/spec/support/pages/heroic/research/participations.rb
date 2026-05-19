# frozen_string_literal: true

require "attr_extras"
require Rails.root.join("spec/pages/page_object.rb")

module Pages
  module Heroic
    module Research
      class Participations < ::Pages::PageObject
        pattr_initialize :study

        def go
          visit research.study_participations_path(study)
          self
        end
      end
    end
  end
end
