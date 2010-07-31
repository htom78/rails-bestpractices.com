class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    # uses a block to prevent double render error...
    # because oauth and openid use redirects
    @user_session.save do |result|
      if result
        flash[:notice] = "Login successful!"
        if current_user
          redirect_to root_url
        else
          redirect_to new_user_session_url
        end
      else
        if @user_session.errors.on(:user)
          # if we set error on the base object, likely it's because we didn't find a user
          render :action => :confirm
        else
          render :action => :new
        end
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end
end
