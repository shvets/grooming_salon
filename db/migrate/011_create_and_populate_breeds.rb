class CreateAndPopulateBreeds < ActiveRecord::Migration
  def self.up
    create_table :breeds do |t|
      t.string :name, :null => false
      t.string :subtype, :null => false
      t.timestamps
    end

    cat_breeds = read_breeds "db/migrate/cat_breeds.txt"
    dog_breeds = read_breeds "db/migrate/dog_breeds.txt"

    for breed in cat_breeds
      Breed.create :name => breed, :subtype => "cat"
    end

    for breed in dog_breeds
      Breed.create :name => breed, :subtype => "dog"
    end
  end

  def self.read_breeds file_name
    breeds = []
    
    File.open(file_name).each_line { |line| breeds << line unless line.empty? or line.chomp.empty? }

    breeds
  end

  def self.down
    drop_table :breeds
  end
end
