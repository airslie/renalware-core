class AddOrcOrderStatusToFeedMessages < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      # A	Some, but not all, results available
      # CA	Order was canceled
      # CM	Order is completed
      # DC	Order was discontinued
      # ER	Error, order not found
      # HD	Order is on hold
      # IP	In process, unspecified
      # RP	Order has been replaced
      # SC In process, scheduled
      begin
        create_enum :enum_hl7_orc_order_status, %w(A CA CM DC ER HD IP RP SC)
      rescue ActiveRecord::StatementInvalid => e
        if e.cause&.class == PG::DuplicateObject
          # Type already exists which is fine as we may have manually added this type out-of-band
          # in order to get ahead of the game in retrospectively populating the new
          # orc_order_status column
          puts "!! Skipping creation of enum_hl7_orc_order_status type as it already exists"
        else
          raise e
        end
      end

      begin
        add_column :feed_messages, :orc_order_status, :enum, enum_type: :enum_hl7_orc_order_status
      rescue ActiveRecord::StatementInvalid => e
        if e.cause&.class == PG::DuplicateColumn
          # See above comment
          puts "!! Skipping creation of feed_messages.orc_order_status column it already exists"
        else
          raise e
        end
      end
    end
  end
end
