class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :name
      t.references :category, index: true
      t.references :account, index: true
      t.bigdecimal :value
      t.string :description
      t.datetime :date

      t.timestamps
    end
  end
end
