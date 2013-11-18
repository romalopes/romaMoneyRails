class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :user_id
      t.decimal :balance
      t.string :description

      t.timestamps
    end
   	add_index :accounts, [:user_id, :created_at]
  end
end
