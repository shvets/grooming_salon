require 'list_filter'

ActionController::Base.send :include, ListFilter
ActionController::Base.send :include, ListFilter::Controller

ActionController::Base.helper ListFilter::Helper
