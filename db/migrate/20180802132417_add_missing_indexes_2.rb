class AddMissingIndexes2 < ActiveRecord::Migration[5.1]
  def change
    # These indexes where missed as we had used the add_column method passing in index: true
    # but that is not supported so no index was created
    add_index :addresses, :country_id
    add_index :patients, :country_of_birth_id
    add_index :patients, :sent_to_ukrdc_at
    add_index :patients, :send_to_renalreg
    add_index :patients, :send_to_rpv
    add_index :patient_bookmarks, :urgent
    add_index :letter_recipients, :emailed_at
    add_index :letter_recipients, :printed_at
    add_index :hospital_wards, :code
    add_index :feed_messages, :patient_identifier
    add_index :access_procedures, :performed_by
    add_index :patient_ethnicities, :cfh_name
  end
end
