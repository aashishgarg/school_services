# frozen_string_literal: true

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      if user.inactive?
        redirect_to new_session_url, alert: "Account is inactive."
      else
        start_new_session_for user
        redirect_to after_authentication_url
      end
    else
      redirect_to new_session_url, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_url
  end
end
