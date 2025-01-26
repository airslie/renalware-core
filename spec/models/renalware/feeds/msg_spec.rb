module Renalware
  describe Feeds::Msg do
    it :aggregate_failures do
      is_expected.to have_db_index(:orc_filler_order_number)
      is_expected.to have_db_index(:message_control_id)
    end
  end
end
