# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ProtectedController < ApplicationController
  # Store the current URL so we can redirect back to it if necessary
  before_filter :store_locations, :check_auth

  private

  # Store where we are
  def store_locations
    session['prevpage'] = session['thispage']
    session['thispage'] = request.request_uri

    #if session['prevpage'] != nil && session['thispage'] != nil && 
    #   session['prevpage'] && session['thispage'] != request.request_uri
      #session['prevpage'] = session['thispage'] || ''
      #session['thispage'] = request.request_uri
    #end
  end

  def check_auth
    unless session[:user]
      flash[:error] = 'You need to be logged in to access this panel'
      redirect_to :controller => 'home', :action => 'login'
    end
  end

  def edit(id, action, &find_item_code)
    begin
      if block_given?
        yield find_item_code
      end
    rescue ActiveRecord::RecordNotFound
      logger.error("Wrong ID: " + id)
      flash[:error] = "Wrong ID: " + id

      redirect_to :action => action
    end
  end

end
