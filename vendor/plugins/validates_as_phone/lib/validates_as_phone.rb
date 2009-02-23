module ActiveRecord
  module Validations
    module ClassMethods
      def validates_as_phone(*args)
        configuration = { :message => ActiveRecord::Errors.default_error_messages[:invalid], :on => :save, :with => nil }
        configuration.update(args.pop) if args.last.is_a?(Hash)
        
        
        validates_each(args, configuration) do |record, attr_name, value|
          valid_lengths = [ 7, 10, 11]
          new_value = value.to_s.gsub(/[^0-9]/,'')
          new_value ||= ''

          logger.info("VALIDATES_AS_PHONE: #{new_value} is the value #{new_value.length}  valid? #{valid_lengths.include?(new_value.length)}")
          unless valid_lengths.include?(new_value.length)
            record.errors.add(attr_name, configuration[:message] + ": #{value}")
          end
        end
      end
    end    
  end
end