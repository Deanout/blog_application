class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.integer :zip
      t.string :country
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
