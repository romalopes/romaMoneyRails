class CreateUserAccounts < ActiveRecord::Migration
  def change
    create_table :user_accounts do |t|
      t.integer :user_id
      t.integer :account_id

#      t.references :user, index: true
#      t.references :account, index: true


      t.timestamps
    end
    add_index :user_accounts, :user_id
    add_index :user_accounts, :account_id
    #User can't be associated to a account more than once
    add_index :user_accounts, [:user_id, :account_id], unique: true
  end
end
