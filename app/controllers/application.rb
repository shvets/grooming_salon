# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.                         name

class ApplicationController < ActionController::Base
  #model :user
  include FinderFilter, WillPaginate

  helper :all # include all helpers, all the time

  layout "grooming-salon-layout"

  filter_parameter_logging :password, :username

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'f599262b5622ea5038a3a07071187bd0'

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_userapp_session_id'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  # Pick a unique cookie name to distinguish our session data from others'

#  before_filter :check_cookie

#  def check_cookie
#    return if session[:user]
#      if cookies[:userapp_login]
#        @user = User.find_by_username(cookies[:userapp_login])
#        return unless @user 
#        cookie_hash = Digest::MD5.hexdigest(cookies[:userapp_login_pass] + @user.password_salt)
#        if @user.cookie_hash == cookie_hash
#          flash[:info] = 'You\'ve been automatically logged in' # annoying msg
#          session[:user] = @user.id
#        else 
#          flash[:notice] = 'Something is wrong with your cookie'
#        end
#      end
#  end

  protected

  def reset_flash_messages
    flash[:notice] = nil
    #flash[:error] = nil
  end

  if RAILS_ENV == 'developpment'
    def method_missing name, *args
      render :inline => %{ 
        <h2>Unknown action: #{name}</h2> 
        Query parameters: <br>
        <%= debug(params) %>
      }
    end
  end
end

#ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
#  :default => "%m/%d/%Y",
#  :date_time12 => "%m/%d/%Y %I:%M%p",
#  :date_time24 => "%m/%d/%Y %H:%M"
#)
