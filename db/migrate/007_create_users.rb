class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.boolean :admin
      t.column :password_salt, :string
      t.column :password_hash, :string
      t.column :email, :string
      t.column :cookie_hash, :string

      t.integer :company_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
