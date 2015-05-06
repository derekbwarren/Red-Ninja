class SessionsController < ApplicationController
  def new
  end

  def create
    user = Admin.find_by(email: params[:session][:email].downcase)
    #if params[:session][:email] && params[:session][:email].downcase=="admin@admin.com"
    if user
        if user.authenticate(params[:session][:password])
          flash.now[:flash] = 'Successfully logged in'
          admin_log_in user
          render 'admins/home'
        else
          #create an error message
          flash.now[:danger] = 'Invalid email/password combination'
          render 'new'
        end
    else
      user = AdvisorUser.find_by(username: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        # log the user in and redirect to some page
        flash.now[:flash] = 'Successfully logged in'
        log_in user
        render 'advisor/index'
      else
        #create an error message
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
      end
    end
  end

  def emailforgotpassword
    adminuser = Admin.find_by(email: params[:session][:email].downcase)
    if adminuser 
      respond_to do |format|
        format.html { redirect_to forgotpassword_path, notice: 'YAYadmin' }
        UserMailer.forgot_password(adminuser).deliver_now
      end
    else
      advisoruser = AdvisorUser.find_by(username: params[:session][:email].downcase)
      if advisoruser
        respond_to do |format|
          format.html { redirect_to forgotpassword_path, notice: 'YAYadvisor' }
          UserMailer.forgot_password(advisoruser).deliver_now
        end
      else
        respond_to do |format|
          format.html { redirect_to forgotpassword_path, notice: 'NO USER' }
        end
      end
    end
  end
 
  def editforgotpassword
    render 'sessions/forgotpassword'
  end

  def destroy
  end
end
