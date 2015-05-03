class CustomersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_client

  def remove
    @customer = Customer.find(params[:customer_id])
    @customer.update_attributes(cancelled: true)
    @current_amount_of_people_in_line = @client.customers_in_line.count
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @customer, status: :accepted }
    end
  end

  def buzz
    @customer = Customer.find(params[:customer_id])
    account_sid = 'ACedd9df9b479477dcb98b3520a475089c'
    auth_token = '7d3f51c5c50aec6cb12668c5efc107e4'
    begin
      client = Twilio::REST::Client.new account_sid, auth_token
      client.messages.create(
        from: '+15617392754',
        to: "+1#{@customer.phone_number}",
        body: "Bzz!"
      )
    rescue => e
      logger.info "Twilio error:"
      logger.info e.inspect
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @customer, status: :accepted }
    end
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update_attributes(served: true, served_time: Time.now)
    @current_amount_of_people_in_line = @client.customers_in_line.count

    @average_wait_time = Customer.average_wait_time

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @customer, status: :accepted }
    end
  end
  def create
    @current_amount_of_people_in_line = @client.customers_in_line.count

    @customer = Customer.new(customer_params)
    @customer.client_id = @client.id
    @customer.save
    account_sid = 'ACedd9df9b479477dcb98b3520a475089c'
    auth_token = '7d3f51c5c50aec6cb12668c5efc107e4'

    begin
      client = Twilio::REST::Client.new account_sid, auth_token
      client.messages.create(
        from: '+15617392754',
        to: "+1#{@customer.phone_number}",
        body: "You have been added to the line. There are #{@current_amount_of_people_in_line} people ahead of you. You'll be buzzed 5 minutes before your turn."
      )
    rescue => e
      logger.info "Twilio error:"
      logger.info e.inspect
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @customer, status: :accepted }
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:phone_number, :name)
  end
end
