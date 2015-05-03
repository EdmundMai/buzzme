class AddCancelBooleanToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :cancelled, :boolean
  end
end
