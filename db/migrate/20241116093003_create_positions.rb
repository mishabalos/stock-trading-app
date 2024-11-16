class CreatePositions < ActiveRecord::Migration[7.2]
  def change
    create_table :positions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :symbol
      t.integer :quantity
      t.decimal :average_price

      t.timestamps
    end
  end
end
