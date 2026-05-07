# frozen_string_literal: true

require "collection_presenter"

module Renalware
  module Heroic
    module BioBank
      class UploadPresenter < SimpleDelegator
        def aliquots
          CollectionPresenter.new(super, BioBank::AliquotPresenter)
        end

        def usages
          CollectionPresenter.new(super, BioBank::UsagePresenter)
        end
      end
    end
  end
end
