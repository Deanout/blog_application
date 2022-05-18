class AddBillingLocationToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :city, :string
    add_column :users, :country, :string
  end
end
