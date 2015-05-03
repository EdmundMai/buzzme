class QueuesController < ApplicationController
  before_action :authenticate_client!

  def show
    @queue = current_client.customers_in_line
    @customer = Customer.new

    @average_wait_time = Customer.average_wait_time
    respond_to do |format|
      format.html
      format.js
    end
  end
end
