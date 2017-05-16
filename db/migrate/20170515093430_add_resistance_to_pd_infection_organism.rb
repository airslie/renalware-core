class AddResistanceToPDInfectionOrganism < ActiveRecord::Migration[5.0]
  def change
    add_column :pd_infection_organisms, :resistance, :text
  end
end
