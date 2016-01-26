class ChargesController < ApplicationController
  def new
  end

  def create
    # Amount in cents
    @booking = Booking.last
    @service = @booking.service
    @amount = @booking.total_price(@service)*100

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'eur'
    )
    @booking.mailer_new_booking

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

end