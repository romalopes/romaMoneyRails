class CreateGroupCategories < ActiveRecord::Migration
  def change
    create_table :group_categories do |t|
      t.string :name
      t.string :image
      t.string :group_type

      t.timestamps
    end
  end
end
