class QueuesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_client

  def show
    @queue = @client.customers_in_line
    @customer = Customer.new

    @average_wait_time = Customer.average_wait_time
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @queue }
    end
  end

  def post_show
    @queue = @client.customers_in_line
    @customer = Customer.new

    @average_wait_time = Customer.average_wait_time
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @queue }
    end
  end
end
