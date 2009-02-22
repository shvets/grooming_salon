## app/controllers/pet_images_controller.rb

require 'ftools'

class PetImagesController < ProtectedController

  def index
    flash[:parent_id] = params[:parent_id]
    
#    render :partial => 'upload/upload_file'

    #@pet_image = PetImage.find_by_pet_id(params[:parent_id])
    #send_data @pet_image.data, :filename => @pet_image.filename, :type => @pet_image.content_type
 
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def redirect_to_parent
    redirect_to :controller => 'pets', :action => 'index'
  end

  def upload_file
    if params[:upload].blank? || params[:upload][:datafile].blank?
      flash[:notice] = 'Empty selection'      
      render :partial => 'upload/upload_file'
    else
      if save(params[:upload], flash[:parent_id])
        flash[:notice] = 'File has been uploaded successfully'

        redirect_to_parent
      else
        flash[:error] = "There was a problem submitting your attachment."
        render :partial => 'upload/upload_file'
      end
    end
  end

  def save upload, parent_id = nil
    @pet_image = PetImage.find_by_pet_id(parent_id)
    
    if @pet_image == nil
      @pet_image = PetImage.new
    end

    @pet_image.pet_id = parent_id
    
    @pet_image.uploaded_image = upload[:datafile]

    @pet_image.save
    
    save_file upload, parent_id
  end

  def save_file upload, parent_id = nil
    name =  upload['datafile'].original_filename
    directory = "public/data/pet_images/#{parent_id}/"

    File.makedirs directory
    # create the file path
    path = File.join(directory, sanitize_filename(name))
    # write the file

    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end
  
  def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all none alphanumeric, underscore or perioids
    # with underscore
    just_filename.sub(/[^\w\.\-]/,'_') 
  end
  
end
