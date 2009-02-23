#

if RAILS_ENV == "test"
  class ActiveRecord::ConnectionAdapters::AbstractAdapter
    @@queries = []
    cattr_accessor :queries
  
    def log_info_with_trace(sql, name, runtime)
      return unless @logger and @logger.debug?
      self.queries << sql
      #log_info_without_trace(sql, name, runtime)
      puts "sql: " + sql
    end
  
    alias_method_chain :log_info, :trace
  end
end

module ActionView
  module Helpers
    module ActiveRecordHelper
      def error_messages_for(*params)
        options = params.extract_options!.symbolize_keys
        objects = params.collect {|name| instance_variable_get("@#{name}") }
        error_messages = objects.map {|o| o.errors.full_messages}
        unless error_messages.flatten!.empty?
          if options[:partial]
            render :partial => options[:partial],
                   :locals  => {:errors => error_messages}
          else
            #header = "Whoops! Please correct the following errors:"
            error_list = error_messages.map {|m| content_tag(:li, m)}
            contents = ''
            #contents << content_tag(:h2, header)
            contents << content_tag(:ul, error_list)
            content_tag(:div, contents,
                        :class => 'errorExplanation',
                        :id    => 'errorExplanation')
          end
        else
          ''
        end
      end
    end
  end
end
