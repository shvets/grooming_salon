# == Schema Information
# Schema version: 12
#
# Table name: users
#
#  id            :integer(11)     not null, primary key
#  username      :string(255)     
#  admin         :boolean(1)      
#  password_salt :string(255)     
#  password_hash :string(255)     
#  email         :string(255)     
#  cookie_hash   :string(255)     
#  company_id    :integer(11)     
#  created_at    :datetime        
#  updated_at    :datetime        
#

class ActiveRecord::Base
  def self.encrypt(*attr_names)
    encrypter = Encrypter.new(attr_names)

    before_save encrypter
    after_save  encrypter
    after_find  encrypter

    define_method(:after_find) { }
  end
end

class User < ActiveRecord::Base
  encrypt(:email)

  attr_protected :admin, :password_salt, :password_hash

  belongs_to :company

  validates_presence_of :username, :password
  validates_uniqueness_of :username
  validates_confirmation_of :password

  def validate
    errors.add_to_base("Missing password") if password_hash.blank?
  end

  attr_reader :password

  def password=(pw)
    @password = pw # used by confirmation validator

    salt = User.calculate_salt

    self.password_salt, self.password_hash = salt, User.encrypted_password(pw, salt)
  end

  def self.calculate_salt
    [Array.new(6){rand(256).chr}.join].pack("m").chomp # 2^48 combos
  end

  def self.encrypted_password pw, salt
    Digest::MD5.hexdigest(pw + salt)
  end

  def password_is?(pw)
    Digest::MD5.hexdigest(pw + password_salt) == password_hash
  end

  def self.current_user(session)
    if session[:user]
      User.find(session[:user])
    end
  end
  
  def admin
    super || username == 'admin' 
  end

  def to_s
    "User { username: #{username}; admin: #{admin}; e-mail: #{email}; company: #{company.name if company != nil} }"
  end
end
