# == Schema Information
# Schema version: 12
#
# Table name: companies
#
#  id         :integer(11)     not null, primary key
#  name       :string(255)     
#  address    :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

#

class Company < ActiveRecord::Base
  has_many :groomers
  has_many :pet_owners

  has_many :users

  validates_presence_of :name

  def to_s
    "Company { name: #{name}; address: #{address} }"
  end
end
