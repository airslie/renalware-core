# frozen_string_literal: true

require Rails.root.join("spec/pages/page_object.rb")

module Pages
  module Heroic
    module Research
      class Participation < Pages::PageObject
        def go
          visit admissions_consults_path
          self
        end
      end
    end
  end
end
