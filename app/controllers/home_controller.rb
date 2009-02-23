# home_controller.rb

class HomeController < ApplicationController
  def index
    reset_flash_messages

    @appointments = Appointment.find_by_current_user User.current_user(session), Date.today, params
  end

  def login
    if request.post?
      controller = session['thispage']

      if controller == "login" || controller == nil
        controller = "home"
      end

      @user = User.find_by_username(params[:login])

      if @user and @user.password_is? params[:password]
        session[:user] = @user.id

        #if params[:remember] # if user wants to be remembered
        #  cookie_pass = [Array.new(9){rand(256).chr}.join].pack("m").chomp
        #  cookie_hash = Digest::MD5.hexdigest(cookie_pass + @user.password_salt)
        #  cookies[:userapp_login_pass] = { :value => cookie_pass, :expires => 30.days.from_now }
        #  cookies[:userapp_login] = { :value => @user.username, :expires => 30.days.from_now }
        #  @user.update_attribute(:cookie_hash, cookie_hash)
        #end

        redirect_to :controller => controller, :action => 'index'
      else 
         #@auth_error = 'Wrong username or password'
         flash[:error] = 'Wrong username or password'
      end
    end
  end

  def logout
    #reset_session
    session[:user] = nil

    session['prevpage'] = nil
    session['thispage'] = nil

    flash[:notice] = 'You\'re logged out'

    respond_to do |format|
      format.html { redirect_to :controller => 'home', :action => 'index' }
      format.xml  { head :ok }
    end
  end

end
       