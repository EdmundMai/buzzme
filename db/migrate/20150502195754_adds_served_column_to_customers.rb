class AddsServedColumnToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :served, :boolean
  end
end
