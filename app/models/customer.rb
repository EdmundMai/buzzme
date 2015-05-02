class Customer < ActiveRecord::Base
  belongs_to :client

  def buzz!
  end
end
