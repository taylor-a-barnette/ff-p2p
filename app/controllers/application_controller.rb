class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method(
    :currency_to_integer,
    :today_date,
    :formatted_price,
    :permit_human_param,
    :verify_creator_as_current_user
    #:pledge_present
    )

  def verify_creator_as_current_user(assoc)
    unless current_user.admin? || user_signed_in? && (!assoc.user.nil? && assoc.user == current_user)
      flash[:error] = "Sorry, but that's not available."
      redirect_to root_path
    end
  end

  def require_admin
    unless user_signed_in? and current_user.admin?
      flash[:error] = "Sorry, that page doesn't exist anymore."
      redirect_to root_path
    end
  end

  #DATE METHOD
  def today_date
    Time.zone = 'EST'
    return Time.zone.today.to_formatted_s(:long)
  end

  #FORMATTED PRICE METHOD
  def formatted_price(amount)
    @price = (amount / 100.0)
    return @price
  end

  def currency_to_integer(currency)
    # used primarily to make user entries Stripe-ready
    @floating = (currency.gsub(/[$,]/,'').to_f)*100
    @floating = @floating.to_i
    return @floating
  end

  def permit_human_param
    params.permit(:human)
  end

end
