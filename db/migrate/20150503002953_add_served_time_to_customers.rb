class AddServedTimeToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :served_time, :datetime
  end
end
