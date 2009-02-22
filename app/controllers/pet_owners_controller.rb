# pet_owners_controller.rb

class PetOwnersController < ProtectedController
  finder_filter :pet_owner, :only => [:show, :update, :destroy]

  # GET /pet_owners
  # GET /pet_owners.xml
  def index
    @pet_owners = PetOwner.find_by_current_user User.current_user(session)

    if @pet_owners.empty?
      flash[:notice] = 'We don\'t have any pet owner.'
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pet_owners }
    end
  end

  # GET /pet_owners/1
  # GET /pet_owners/1.xml
  def show
    #@pet_owner = PetOwner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pet_owner }
    end
  end

  # GET /pet_owners/new
  # GET /pet_owners/new.xml
  def new
    reset_flash_messages

    @pet_owner = PetOwner.new(:company_id => User.current_user(session).company_id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pet_owner }
    end
  end

  # GET /pet_owners/1/edit
  def edit
    @pet_owner = super(params[:id], "index") { PetOwner.find(params[:id]) }
  end

  # POST /pet_owners
  # POST /pet_owners.xml
  def create
    @pet_owner = PetOwner.new(params[:pet_owner])

    respond_to do |format|
      if @pet_owner.save
        flash[:notice] = 'Pet owner was successfully created.'
        format.html { redirect_to(pet_owners_url) }
        format.xml  { render :xml => @pet_owner, :status => :created, :location => @pet_owner }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pet_owner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pet_owners/1
  # PUT /pet_owners/1.xml
  def update
    #@pet_owner = PetOwner.find(params[:id])

    respond_to do |format|
      if @pet_owner.update_attributes(params[:pet_owner])
        flash[:notice] = 'Pet owner was successfully updated.'
        format.html { redirect_to(pet_owners_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pet_owner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pet_owners/1
  # DELETE /pet_owners/1.xml
  def destroy
    #@pet_owner = PetOwner.find(params[:id])
    @pet_owner.destroy

    respond_to do |format|
      format.html { redirect_to(pet_owners_url) }
      format.xml  { head :ok }
    end
  end
end
