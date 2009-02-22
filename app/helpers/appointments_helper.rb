module AppointmentsHelper
  #include ActionView::Helpers::DateHelper, ActionView::Helpers::FormOptionsHelper
  
  def display_pets_select
    pets = Pet.find(:all, :conditions => [ "pet_owner_id=?", params[:pet_owner_id] ])

    text = '<select id="appointment_pet_id" name="appointment[pet_id]">'
    
    for pet in pets
      text = text + '  <option value="' + pet.id.to_s + '">' + pet.name + '</option>'
    end

    text = text + '</select>'

    render :text => text
  end

  def effects
    @cart = "bbbbb"
    redirect_to appointments_url unless request.xhr?
  end

end
