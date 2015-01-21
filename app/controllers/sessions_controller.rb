class SessionsController < ApplicationController
  layout "sign_in"

  skip_before_action :authenticate_user!, except: [:destroy]

  def new
    if user_signed_in?
      redirect_to after_signed_in_path_for(current_user), notice: "You already signed in"
    end
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      sign_in(user)

      respond_to do |format|
        format.html do
          redirect_to after_signed_in_path_for(user), notice: "Signed in successfully"
        end
        format.json { head :ok }
      end

    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = "Invalid email/password"
          render :new
        end

        format.json do 
          errors = { success: false, error: "The email or password is incorrect." }
          render json: errors, status: 401
        end
      end
    end

  end

  def destroy
    redirect_to sign_out_and_redirect_for(current_user), notice: "You have been signed out"
  end
end
