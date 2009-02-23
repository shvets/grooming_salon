#

class ValidatingFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
           %w(date_select datetime_select time_select select collection_select) -
           %w(hidden_field label fields_for)
  
  def self.create_tagged_field name
    define_method(name) do |field, *args|
      if %w(text_field password_field).include?(name) && required_field?(field)
        options = args.detect { |argument| argument.is_a?(Hash) }
        if options.nil?
          options = {:onblur => "checkPresence('#{field_name(field)}')"}
          args << options
        else
          options[:onblur] = "checkPresence('#{field_name(field)}')" 
          #unless options.nil?          
        end
    
        #options = args.last.is_a?(Hash) ? args.pop : {}
        #options[:onblur] = "checkPresence('#{field_name(field)}')"
        
        #options2 = args.last.is_a?(Hash) ? args.pop : {}        
        #options2.merge({:onblur => "checkPresence('#{field_name(field)}')"})
        control = super(field, options)
      else
        control = super(field, *args)
      end

      label_options = (required_field?(field)) ? {:style => 'color:red'} : {}
     
      @template.content_tag(:p,
                            label(field, label_text(field), label_options) + ": " +
                            control)    
    end
  end
   
  helpers.each do |name|
    create_tagged_field name
  end
  
 # def text_field_with_auto_complete object, method, tag_options = {}, completion_options = {}
 #   text_field_with_auto_complete object, method, tag_options, completion_options
 # end
  
private
  def field_name(field)
   "#{@object_name.to_s.underscore}_#{field.to_s.underscore}"
  end

  def label_text(field)
    "#{field.to_s.humanize}"
  end

  def required_field?(field)
    @object_name.to_s.camelize.constantize.
                 reflect_on_validations_for(field).
                 map(&:macro).include?(:validates_presence_of)
  end
end

