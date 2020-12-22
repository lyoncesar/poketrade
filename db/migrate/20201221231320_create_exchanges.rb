class CreateExchanges < ActiveRecord::Migration[6.0]
  def change
    create_table :exchanges do |t|
      t.text :sending, array: true, default: []
      t.text :receiving, array: true,  default: []
      t.decimal :avg_sending, default: 0.0
      t.string :avg_receiving, default: 0.0

      t.timestamps
    end
  end
end
