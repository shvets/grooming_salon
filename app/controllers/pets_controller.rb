# pets_controller.rb

class PetsController < ProtectedController
#  include AutoCompleteMacrosHelper,
#          ActionView::Helpers::TagHelper,
 #         ActionView::Helpers::FormHelper,
  #        ActionView::Helpers::JavaScriptHelper 

  finder_filter :pet, :only => [:show, :update, :destroy]

  #skip_before_filter :verify_authenticity_token

  auto_complete_for :pet_owner, :first_name

  # GET /pets
  # GET /pets.xml
  def index
    @pets = Pet.find_by_current_user User.current_user(session), params
    
    if @pets.empty?
      flash[:notice] = 'We don\'t have any pet.'
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pets }
    end
  end

  # GET /pets/1
  # GET /pets/1.xml
  def show
    #@pet = Pet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pet }
    end
  end

  # GET /pets/new
  # GET /pets/new.xml
  def new
    reset_flash_messages

    @pet = Pet.new(:pet_owner_id => params[:pet_owner_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pet }
    end
  end

  # GET /pets/1/edit
  def edit
    @pet = super(params[:id], "index") { Pet.find(params[:id]) }
  end

  # POST /pets
  # POST /pets.xml
  def create
    synchronize_params params

    if breed_is_blank? params
      flash[:error] = "Breed can't be blank."
    end
    
    @pet = Pet.new(params[:pet])

    respond_to do |format|
      if !breed_is_blank?(params) && @pet.save
        flash[:notice] = 'Pet was successfully created.'
        format.html { redirect_to(pets_url) }
        format.xml  { render :xml => @pet, :status => :created, :location => @pet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pets/1
  # PUT /pets/1.xml
  def update
    #@pet = Pet.find(params[:id])

    synchronize_params params

    if breed_is_blank? params
      flash[:error] = "Breed can't be blank."
    end
    
    respond_to do |format|
      if !breed_is_blank?(params) && @pet.update_attributes(params[:pet])
        flash[:notice] = 'Pet was successfully updated.'
        format.html { redirect_to pets_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pet.errors, :status => :unprocessable_entity }
      end
    end
  end

  def synchronize_params params
    if params[:pet][:subtype] == 'cat'
      params[:pet][:breed] = params[:cat][:breed]
    elsif params[:pet][:subtype] == 'dog'
      params[:pet][:breed] = params[:dog][:breed]
    end
  end
  
  def breed_is_blank? params
    params[:cat][:breed].blank? && params[:dog][:breed].blank?
  end
  
  # DELETE /pets/1
  # DELETE /pets/1.xml
  def destroy
    #@pet = Pet.find(params[:id])
    @pet.destroy

    respond_to do |format|
      format.html { redirect_to(pets_url) }
      format.xml  { head :ok }
    end
  end

  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_cat_breed, :auto_complete_for_dog_breed]    
  
  def auto_complete_for_cat_breed
    auto_complete_for_pet_breed 'cat', params[:cat][:breed]
  end

  def auto_complete_for_dog_breed
    auto_complete_for_pet_breed 'dog', params[:dog][:breed]
  end
  
  def auto_complete_for_pet_breed subtype, param
    breeds = Breed.find(:all, :conditions => [ 'LOWER(name) LIKE ? and subtype=?', '%' + param.downcase + '%', subtype ], 
                               :order => 'name ASC', :limit => 10)
    text = '<ul>'
    
    for breed in breeds
      text = text + '<li>' + breed.name + '</li>'
    end

    text = text + '</ul>'

    render :text => text
  end

#def auto_complete_for_doctor_organization
#  re = Regexp.new("^#{params[:doctor][:organization]}", "i")
#  find_options = { :order => "name ASC" }
#  @organizations = Organization.find(:all, find_options).collect(&:name).select { |org| org.match re }
        
#  render :inline => "<%= content_tag(:ul, @organizations.map { |org| content_tag(:li, h(org)) }) %>"
#end

end
