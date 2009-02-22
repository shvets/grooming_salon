#

require "migration_helpers"

class AddConstraintsToTables < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    foreign_key :users, :company_id, :companies
    foreign_key :groomers, :company_id, :companies
    foreign_key :pet_owners, :company_id, :companies

    #foreign_key :pets, :pet_owner_id, :pet_owners

    #execute "alter table appointments add constraint fk_appointment_pet_owners foreign key (pet_owner_id) references pet_owners(id)"
    #foreign_key :appointments, :pet_owner_id, :pet_owners
    foreign_key :appointments, :pet_id, :pets
    foreign_key :appointments, :groomer_id, :groomers
  end

  def self.down
    drop_foreign_key :users, :company_id

    execute "alter table users drop constraint fk_user_companies"

    execute "alter table groomers drop constraint fk_groomer_companies"

    execute "alter table pet_owners drop constraint fk_pet_owner_companies"

    execute "alter table pets drop constraint fk_pet_pet_owners"

    #execute "alter table appointments drop constraint fk_appointment_pet_owners"
    execute "alter table appointments drop constraint fk_appointment_pets"
    execute "alter table appointments drop constraint fk_appointment_groomers"
  end
end
