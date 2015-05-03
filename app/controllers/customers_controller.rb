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
    account_sid = 'ACb8256459f9633549e11b36ee32350d4a'
    auth_token = 'f52a12c12f07aab793d8858a15fddf15'
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
    id = params[:customer_id] || params[:id]
    @customer = Customer.find(id)
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
    account_sid = 'ACb8256459f9633549e11b36ee32350d4a'
    auth_token = 'f52a12c12f07aab793d8858a15fddf15'


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

  ['remove', 'buzz', 'create', 'update'].each do |method_name|
    alias_method "post_#{method_name}", method_name
  end

  private

  def customer_params
    params.require(:customer).permit(:phone_number, :name)
  end
end
