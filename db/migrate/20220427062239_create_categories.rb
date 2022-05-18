class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :display_in_nav, default: false

      t.timestamps
    end
  end
end
