# == Schema Information
# Schema version: 12
#
# Table name: appointments
#
#  id               :integer(11)     not null, primary key
#  appointment_date :date            
#  appointment_time :time            
#  price            :float           default(0.0)
#  pet_owner_id     :integer(11)     
#  groomer_id       :integer(11)     
#  pet_id           :integer(11)     
#  created_at       :datetime        
#  updated_at       :datetime        
#

#

class Appointment < ActiveRecord::Base
  belongs_to :pet_owner
  belongs_to :groomer
  belongs_to :pet

  validates_presence_of :appointment_date, :price, :pet_owner_id, :pet_id, :groomer_id
 
  validates_numericality_of :price, :message=>"should be a number"

  def validate
    errors.add_to_base("Price should be positive and different from 0") if !price.blank? && price <= 0
  end

  def self.construct_date filter
    Date.new y=filter.to_hash['value(1i)'].to_i, m=filter.to_hash['value(2i)'].to_i, d=filter.to_hash['value(3i)'].to_i
  end
    
  def self.find_by_current_user current_user, current_date, params
    pet_owner_ids = []
  
    filter_value = nil
    
    if params[:filter] != nil
      filter_id = params[:filter_id]
    
      if filter_id == "PETOWNER"
        params[:pet_owner_id] = params[:filter][:value]
       #filter_value = params[:filter][:value]
      elsif filter_id == "DATE"
        current_date = construct_date params[:filter]
      end       
    end    

#    if filter_value != nil
      #params[:subtype] = filter_value
#      conditions = [ "subtype = ?", filter_value]
#    else
#      conditions = []
#    end
    
    
    
    if current_user != nil
      if current_user.admin
        if params[:pet_owner_id] != nil
          pet_owner_ids << params[:pet_owner_id]
        end
      else
        if current_user.company != nil && current_user.company.id
          pet_owner_ids = PetOwner.find(:all, :conditions => ["company_id=?", current_user.company.id]).collect() { |x| x.id }
        else
          pet_owner_ids = []

          if params[:pet_owner_id] != nil
            pet_owner_ids << params[:pet_owner_id]
          end
        end
      end
    end

    if pet_owner_ids.size() == 0
      conditions = {}
    else
      pet_ids = Pet.find(:all, :conditions => [ "pet_owner_id in(?)", pet_owner_ids])

      conditions = { :pet_id => pet_ids }
    end
    
    if current_date != nil
      conditions[:appointment_date] = current_date
    end

    find(:all, :conditions => conditions)
  end

  def to_s
    "Appointment { owner: #{pet_owner.name if pet_owner != nil}; pet: ${pet.name if pet != nil}; appointment_date: #{appointment_date}; price: #{price} }"
  end
end
