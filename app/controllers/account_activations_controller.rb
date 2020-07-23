class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
    user.activate
    log_in user
    flash[:success] = "Account activated"
    session[:session_token] = user.session_token #not sure told to ass at 11.3.2
    redirect_to user
    else
    flash[:danger] = "Invalid activation link"
    redirect_to root_url
    end

  end
end
