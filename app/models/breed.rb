# == Schema Information
# Schema version: 12
#
# Table name: breeds
#
#  id         :integer(11)     not null, primary key
#  name       :string(255)     not null
#  subtype    :string(255)     not null
#  created_at :datetime        
#  updated_at :datetime        
#

class Breed < ActiveRecord::Base
  validates_presence_of :name, :subtype  
end
