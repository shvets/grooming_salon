class CreateAppointments < ActiveRecord::Migration
  def self.up
    create_table :appointments do |t|
      t.date :appointment_date
      t.time :appointment_time
      t.float :price, :precision => 8, :scale => 2, :default => 0
    
      t.integer :pet_owner_id
      t.integer :groomer_id
      t.integer :pet_id

      t.timestamps
    end
  end

  def self.down
    drop_table :appointments
  end
end
