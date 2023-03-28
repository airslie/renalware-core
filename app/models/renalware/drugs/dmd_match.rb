# frozen_string_literal: true

module Renalware::Drugs
  class DMDMatch < ApplicationRecord
    belongs_to :drug
  end
end
