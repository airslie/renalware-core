class AddOvernightBagToPDRegimeBags < ActiveRecord::Migration[4.2]
  def change
    add_column :pd_regime_bags, :capd_overnight_bag, :boolean, null: false, default: false
  end
end
