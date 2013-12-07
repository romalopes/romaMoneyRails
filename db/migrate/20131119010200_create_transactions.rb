class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :name
      t.references :category, index: true
      t.references :account, index: true
      t.decimal :value
      t.string :description
      t.date :date

      t.timestamps
    end
  end
end
