# groomers_controller.rb

class GroomersController < ProtectedController
  finder_filter :groomer, :only => [:show, :update, :destroy]

  # GET /groomers
  # GET /groomers.xml
  def index
    @groomers = Groomer.find_by_current_user User.current_user(session), params

    if @groomers.empty?
      flash[:notice] = 'We don\'t have any groomer.'
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groomers }
    end
  end

  # GET /groomers/1
  # GET /groomers/1.xml
  def show
    #@groomer = Groomer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @groomer }
    end
  end

  # GET /groomers/new
  # GET /groomers/new.xml
  def new
    reset_flash_messages

    @groomer = Groomer.new(:company_id => User.current_user(session).company_id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @groomer }
    end
  end

  # GET /groomers/1/edit
  def edit
    @groomer = super(params[:id], "index") { Groomer.find(params[:id]) }
  end

  # POST /groomers
  # POST /groomers.xml
  def create
    @groomer = Groomer.new(params[:groomer])

#    @groomer.company_id = User.current_user(session).company_id if User.current_user(session).company_id

    respond_to do |format|
      if @groomer.save
        flash[:notice] = 'Groomer was successfully created.'
        format.html { redirect_to(groomers_url) }
        format.xml  { render :xml => @groomer, :status => :created, :location => @groomer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @groomer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groomers/1
  # PUT /groomers/1.xml
  def update
    #@groomer = Groomer.find(params[:id])

    respond_to do |format|
      if @groomer.update_attributes(params[:groomer])
        flash[:notice] = 'Groomer was successfully updated.'
        format.html { redirect_to(groomers_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @groomer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groomers/1
  # DELETE /groomers/1.xml
  def destroy
    #@groomer = Groomer.find(params[:id])
    @groomer.destroy

    respond_to do |format|
      format.html { redirect_to(groomers_url) }
      format.xml  { head :ok }
    end
  end
end
