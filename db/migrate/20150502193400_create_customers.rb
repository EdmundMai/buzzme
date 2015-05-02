class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :client_id
      t.string :name
      t.string :phone_number

      t.timestamps null: false
    end
  end
end
