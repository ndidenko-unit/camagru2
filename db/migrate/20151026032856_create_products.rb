class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :user_id, null: false
      t.string :name
      t.string :image

      t.timestamps null: false
    end
  end
end
