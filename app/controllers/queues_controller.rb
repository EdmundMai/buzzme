class QueuesController < ApplicationController
  before_action :authenticate_client!

  def show
    @queue = current_client.customers_in_line
    @customer = Customer.new
  end
end
