# companies_controller.rb

class CompaniesController < ProtectedController
  #@display_map = false
  #class << self; attr_reader :display_map; end
  
  finder_filter :company, :only => [:show, :update, :destroy]

  # :param => :id
  # :by => :name, :except => [:index]

  # GETs should be safe (see  http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :index }

  [:name, :address].each do |attribute|
    in_place_edit_for :company, attribute, :empty_text => '...'
  end 
  
  protect_from_forgery :except => [:set_company_name, :set_company_address] 

  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end
 
  # GET /companies/1
  # GET /companies/1.xml
  def show
    #@company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = super(params[:id], "index") { Company.find(params[:id]) }
  end

  # POST /companies
  # POST /companies.xml
  def create
    reset_flash_messages

    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        flash[:notice] = 'Company was successfully created.'
        format.html { redirect_to(companies_url) }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    #@company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = 'Company was successfully updated.'
        format.html { redirect_to(companies_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    #@company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end

end
