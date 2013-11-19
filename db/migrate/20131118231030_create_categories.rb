class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :image
      t.string :description
      t.integer :group_category_id

      t.timestamps
    end
    add_index :categories, [:group_category_id, :created_at] 
  end
end
