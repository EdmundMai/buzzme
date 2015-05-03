class AddIndustryAndCompanyNameToClients < ActiveRecord::Migration
  def change
    add_column :clients, :industry, :string
    add_column :clients, :company_name, :string
  end
end
