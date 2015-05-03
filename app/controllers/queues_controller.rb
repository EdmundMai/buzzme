class QueuesController < ApplicationController
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

  def set_client
    @client ||= if ios_app?
      Client.find(params[:client_id])
    else
      current_client
    end
  end

  def ios_app?
    params[:os].present?
  end
end
