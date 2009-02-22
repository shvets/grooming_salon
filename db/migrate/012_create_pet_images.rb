class CreatePetImages < ActiveRecord::Migration
  def self.up
    create_table :pet_images do |t|
      t.column :filename,         :string
      t.column :content_type, :string
      # If using MySQL, blobs default to 64k, so we have to give
      # an explicit size to extend them
      #t.column :data,         :binary, :limit => 4.megabytes

      t.column :pet_id, :integer
    end
  end

  def self.down
    drop_table :pet_images
  end
end
