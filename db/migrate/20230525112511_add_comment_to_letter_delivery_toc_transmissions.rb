class AddCommentToLetterDeliveryTocTransmissions < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :letter_delivery_toc_transmissions, :comment, :text
    end
  end
end
