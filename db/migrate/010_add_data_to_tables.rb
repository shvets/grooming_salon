#

class AddDataToTables < ActiveRecord::Migration
  def self.up
    Company.create :name => "Goochie Pooch & Cats Too", :address => "737 State Route 18 East Brunswick, NJ 08816-4904 ", :phone => "732-432-9191" # 1
    Company.create :name => "Paws Pet Grooming & Supplies", :address => "1905 Highway 33 # 8, Trenton, NJ", :phone => "(609) 586-9860"          # 2

    User.create :username => "admin", :admin => true, :password => 'admin'
    User.create :username => "gp", :admin => false, :password => 'gp', :company_id => 1
    User.create :username => "paws", :admin => false, :password => 'paws', :company_id => 2

    Groomer.create :first_name => "Inna", :last_name => "Shvets", :company_id => 1
    Groomer.create :first_name => "Carrol", :last_name => "Pollak", :company_id => 2

    PetOwner.create :first_name => "Inna", :last_name => "Shvets", :home_phone => "(609) 222-2222", :company_id => 1
    PetOwner.create :first_name => "Lisa", :last_name => "Ribansky", :home_phone => "(712) 333-3333", :company_id => 2

    Pet.create :subtype => "cat", :name => "Cheeta", :sex => "female", :breed => "siameze",
      :color => "white", :size => 10, :birth_date => '12-12-2008',
      :veterinar => "v1", :referred_by => 'rb1', :alive => 'yes', :pet_owner_id => 1

    Pet.create :subtype => "cat", :name => "Sheila", :sex => "female", :breed => "persian",
      :color => "gray", :size => 5, :birth_date => '12-12-2008',
      :veterinar => "v1", :referred_by => 'rb1', :alive => 'yes', :pet_owner_id => 2

    Appointment.create :appointment_date => "2008-08-07", :appointment_time => "12:30", :price => "40.00",
      :pet_owner_id => 1, :groomer_id => 1, :pet_id => 1

    Appointment.create :appointment_date => "2008-08-07", :appointment_time => "12:45", :price => "50.00",
      :pet_owner_id => 2, :groomer_id => 2, :pet_id => 2
  end

  def self.down
    Company.delete_all
    Company.delete_all

    Groomer.delete_all
    Groomer.delete_all

    PetOwner.delete_all
    PetOwner.delete_all

    Pet.delete_all
    Pet.delete_all

    Appointment.delete_all
  end
end
