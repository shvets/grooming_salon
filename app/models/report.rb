# == Schema Information
# Schema version: 12
#
# Table name: reports
#
#  id          :integer(11)     not null, primary key
#  name        :string(255)     
#  description :string(255)     
#  table       :string(255)     
#  condition   :string(255)     
#  controller  :string(255)     
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Report < ActiveRecord::Base

  def to_s
    "Report { name: #{name}; table: ${table}; controller: #{controller} }"
  end
end
