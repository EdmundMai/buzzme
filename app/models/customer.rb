class Customer < ActiveRecord::Base
  belongs_to :client

  def self.average_wait_time
    total_wait_time = 0
    all.each do |customer|
      total_wait_time = (customer.served_time || Time.now) - customer.created_at + total_wait_time
    end
    total_wait_time / 60.0 / self.count
  end

end
