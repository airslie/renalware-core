class CreateTransplantsRegistrationStatuses < ActiveRecord::Migration
  def change
    create_table :transplants_registration_statuses do |t|
      t.belongs_to :registration, index: true
      t.belongs_to :description, index: true
      t.date :started_on
      t.date :terminated_on
      t.string :whodunnit

      t.timestamps null: false
    end

    add_foreign_key :transplants_registration_statuses,
      :transplants_registrations, column: :registration_id
    add_foreign_key :transplants_registration_statuses,
      :transplants_registration_status_descriptions, column: :description_id
  end
end
