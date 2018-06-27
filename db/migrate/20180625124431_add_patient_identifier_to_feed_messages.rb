# frozen_string_literal: true

class AddPatientIdentifierToFeedMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :feed_messages, :patient_identifier, :string, index: true
  end
end
