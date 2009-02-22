#
       
class BreedsController < ProtectedController
  include ActionView::Helpers::FormOptionsHelper

  finder_filter :breed, :only => [:show, :update, :destroy]

  in_place_edit_for :breed, :subtype, :empty_text => '...'
  
  protect_from_forgery :except => [:set_breed_subtype] 
  
  # GET /breeds
  # GET /breeds.xml
  def index
    filter_value = nil
    
    if params[:filter] != nil
      filter_id = params[:filter_id]
    
      if filter_id == "TYPE"
        filter_value = params[:filter][:value]
      end 
    end    

    if filter_value != nil
      #params[:subtype] = filter_value
      conditions = [ "subtype = ?", filter_value]
    else
      conditions = []
    end

    params[:filter] = 'name' if params[:filter] == nil
    
    #@breeds = Breed.find(:all, :conditions => conditions)
    @breeds = Breed.paginate(:all, :conditions => conditions, :page => params[:page], :per_page => 30)
        
    if @breeds.empty?
      flash[:notice] = 'We don\'t have any breed.'
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @breeds }
    end
  end

  # GET /breeds/1
  # GET /breeds/1.xml
  def show
    #@breed = Breed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @breed }
    end
  end

  # GET /breeds/new
  # GET /breeds/new.xml
  def new
    @breed = Breed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @breed }
    end
  end

  # GET /breeds/1/edit
  def edit
    @breed = Breed.find(params[:id])
  end

  # POST /breeds
  # POST /breeds.xml
  def create
    @breed = Breed.new(params[:breed])

    respond_to do |format|
      if @breed.save
        flash[:notice] = 'Breed was successfully created.'
        format.html { redirect_to(@breed) }
        format.xml  { render :xml => @breed, :status => :created, :location => @breed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @breed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /breeds/1
  # PUT /breeds/1.xml
  def update
    #@breed = Breed.find(params[:id])

    respond_to do |format|
      if @breed.update_attributes(params[:breed])
        flash[:notice] = 'Breed was successfully updated.'
        format.html { redirect_to breeds_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @breed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /breeds/1
  # DELETE /breeds/1.xml
  def destroy
    #@breed = Breed.find(params[:id])
    @breed.destroy

    respond_to do |format|
      format.html { redirect_to(breeds_url) }
      format.xml  { head :ok }
    end
  end

  def display_filter_value_field filter_id = nil
    text = ''

    filter_id = (params[:filter_id] == nil) ? 'TYPE' : params[:filter_id]
    
    if filter_id != nil
      if filter_id == 'TYPE'
        choices = %w(cat dog)
        selected = (params[:filter] == nil) ? 'cat' : params[:filter][:value]
        text = select(:filter, :value, choices, {:selected => selected} )  
      else
        text = ''
      end
    end

    render :text => text

    text
  end

end
