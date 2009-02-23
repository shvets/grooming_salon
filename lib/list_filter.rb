#
module ListFilter
  class Filter
    attr_accessor :id, :name, :type, :code
    
    def initialize(id, name, type, &code)
      @id = id
      @name = name
      @type = type
      @code = code
    end
  end
  
  # Mixin for ActiveRecord::Base to provide some model-level methods
  module Controller
    def get_filter infos, filter_id = nil
      if filter_id != nil
        infos.find(:first) do
          |info| info.id == filter_id 
        end
      else
        infos[0]
      end
    end

    def display_filter
      text = ''

      filter = get_filter filters, params[:filter_id]
 
      if filter.type == 'select'
        text = display_collection_select filter.code.call
      elsif filter.type == "date"
        text = display_date filter.code.call
      else
        text = ''
      end

      render :text => text
    end
  
    def display_collection_select collection
      filter_value_id = (params[:filter] == nil) ? collection[0].id : params[:filter][:value]

      filter_struct = Struct::new(:value)

      @filter = filter_struct.new(filter_value_id.to_i)

      collection_select(:filter, :value, collection, :id, :name) 
    end 

    def display_date date=nil
       date_select(:filter, :value)
    end
  end

  module Helper
    def list_filters
      filters = @controller.filters
      
      filter = @controller.get_filter filters, params[:filter_id]
 
      choices = filters.inject({}) do |options, element|
        options.merge(element.name => element.id)
      end
        
      options = options_for_select(choices, filter.id)

      render :partial => "shared/filter", :locals => { :options => options, :controller => @controller }
      #filter options, @controller 
    end
    
#    def filter options, controller
#      text = ''
#      
#      form_tag('/' + @controller.controller_name, :method => :get) do
#
#      text = text + "Filter by: " +  select_tag("filter_id", options)
#
#      observe_field("filter_id",
#                 :frequency => 0.25,
#                 :update => :display_filter_field_div,
#                 :url => { :controller => @controller.controller_name, :action => :display_filter_value_field },
#                 :with => 'filter_id')
#
#        text = text + "Value:"
#      
#        text = text + '<div id="display_filter_field_div">'
#
#        text = text + @controller.display_filter_value_field
#
#        text = text + '</div>'
#
#        text = text + submit_tag('Filter')
#      end 
#    end
  end
  
end

