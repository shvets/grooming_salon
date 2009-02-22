# == Schema Information
# Schema version: 12
#
# Table name: pets
#
#  id                   :integer(11)     not null, primary key
#  subtype              :string(255)     
#  name                 :string(255)     
#  sex                  :string(255)     
#  breed                :string(255)     
#  color                :string(255)     
#  size                 :string(255)     
#  birth_date           :datetime        
#  veterinar            :string(255)     
#  referred_by          :string(255)     
#  medical_problems     :text            
#  special_instructions :text            
#  behavior             :text            
#  clip1                :string(255)     
#  clip2                :string(255)     
#  clip3                :string(255)     #  pet_owner_id         :integer(11)     
#  alive                :string(255)     
#  created_at           :datetime        
#  updated_at           :datetime        
#

#

class Pet < ActiveRecord::Base
  COLORS = [
    "white",
    "white and black",
    "white and tan",
    "tan",
    "black and tan",
    "red",
    "blue",
    "brown",
    "tricolor (calico)",
    "gray",
    "dark gray",
    "light gray",
  ]

  SEX_TYPES = [
    ["male", "male"], ["female", "female"]
  ]

  belongs_to :pet_owner
  has_many :appointments
  has_one :pet_image
  
  validates_presence_of :name, :subtype, :sex, :breed, :size, :color, :birth_date, :pet_owner_id

  validates_inclusion_of :sex, :in => SEX_TYPES.map { |disp, *| disp}
  
  def self.get_breeds subtype
    Breed.find(:all, :conditions => (subtype == nil) ? [] :  [ "subtype=?", subtype])
  end

  def self.find_by_current_user current_user, params
    if current_user.admin
      pet_owner_ids = []

      if params[:pet_owner_id] != nil
        pet_owner_ids << params[:pet_owner_id]
      end
    else
      if current_user.company.id
        pet_owner_ids = PetOwner.find(:all, :conditions => ["company_id=?", current_user.company.id]).collect() { |x| x.id }
      else
        pet_owner_ids = []

        if params[:pet_owner_id] != nil
          pet_owner_ids << params[:pet_owner_id]
        end
      end
    end

    if pet_owner_ids.size() == 0
      conditions = {}
    else
      conditions = { :pet_owner_id => pet_owner_ids }
    end

    find(:all, :conditions => conditions )
  end
  
  def to_s
    "Pet { name: #{name}; subtype: #{subtype}; sex: #{sex}; breed: #{breed}; color: #{color}; size: #{size}; owner: #{pet_owner.name if pet_owner != nil} }"
  end
end
