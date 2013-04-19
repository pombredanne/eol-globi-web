class RegistrationsController < ApplicationController
  
  def new
    @registration = Registration.new
  end

  def create
    registration = Registration.new(params[:registration])
    if !registration.save
      flash[:error] = "Upsi. Something went wrong. Try again later."
      @registration = Registration.new
      render "new"
    end
  end
  
end
