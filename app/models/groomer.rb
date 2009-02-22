# == Schema Information
# Schema version: 12
#
# Table name: groomers
#
#  id         :integer(11)     not null, primary key
#  first_name :string(255)     
#  last_name  :string(255)     
#  notes      :text            
#  company_id :integer(11)     
#  created_at :datetime        
#  updated_at :datetime        
#

#

class Groomer < ActiveRecord::Base
  belongs_to :company

  has_many :appointments

  validates_presence_of :first_name, :last_name, :company_id

  def name
    last_name + " " + first_name
  end

  def self.find_by_current_user current_user, params
    if current_user.admin
      conditions = []
    else
      conditions = [ "company_id=?", current_user.company_id ]
    end

    find(:all, :conditions => conditions)
  end

  def to_s
    "Groomer { name: #{name}; company: #{company.name if company != nil} }"
  end
end
