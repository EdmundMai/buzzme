class Customer < ActiveRecord::Base
  belongs_to :client

  def self.average_wait_time
    total_wait_time = 0
    where("served_time IS NOT NULL").each do |customer|
      total_wait_time = customer.served_time - customer.created_at + total_wait_time
    end
    total_wait_time / 60.0 / (self.count.zero? ? 1 : self.count)
  end

end
