require File.dirname(__FILE__) + '/test_helper'

class ValidatesAsPhoneTest < Test::Unit::TestCase
  fixtures :person

  def test_single_field_validation
    
    valid_numbers = ["555-1212","5551212","(555)555-1212","(555) 555-1212","555.2121","1.444.555.1212","1(444)555.1212"]
    invalid_numbers = ["222.222.22255","4  14p9r58m,nfdb44555"]    
    
    valid_numbers.each do |number|
      r = Person.new
      r.phone = number
      r.valid?
      # we know there is only one validation so if theres and error it is for this.
      assert r.valid?, "#{r.phone} should be valid but is not: #{r.errors.full_messages}."
      r.destroy
    end
    
    invalid_numbers.each do |number|
      i = Person.new
      i.phone = number.to_s
      i.valid?
      # we know there is only one validation so if theres and error it is for this.
      assert i.errors, "#{i.phone} should not be valid, but is: #{i.phone} #{i.phone.length}."
      i.destroy
    end
      
  end

end
