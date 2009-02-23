class CreatePetOwners < ActiveRecord::Migration
  def self.up
    create_table :pet_owners do |t|
      t.string :first_name
      t.string :last_name
      t.string :home_phone
      t.string :work_phone
      t.string :cell_phone
      t.string :salutation

      t.integer :company_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pet_owners
  end
end
