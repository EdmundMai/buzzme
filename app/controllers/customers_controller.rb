class CustomersController < ApplicationController
  before_action :authenticate_client!

  def buzz
    @customer = Customer.find(params[:customer_id])

    begin
      client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
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
      format.js
    end
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update_attributes(served: true, served_time: Time.now)

    @average_wait_time = Customer.average_wait_time

    respond_to do |format|
      format.js
    end
  end
  def create
    current_amount_of_people_in_line = current_client.customers_in_line.count

    @customer = Customer.new(customer_params)
    @customer.client_id = current_client.id
    @customer.save

    begin
      client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
      client.messages.create(
        from: '+15617392754',
        to: "+1#{@customer.phone_number}",
        body: "You have been added to the line. There are #{current_amount_of_people_in_line} people ahead of you. You'll be buzzed 5 minutes before your turn."
      )
    rescue => e
      logger.info "Twilio error:"
      logger.info e.inspect
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:phone_number, :name)
  end


end
