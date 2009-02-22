#

$:.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'rubygems'
require 'active_support'
require 'action_controller'
require 'action_view'
require 'test/unit'
require 'list_filter'

ActionController::Base.send :include, ListFilter::Controller
ActionController::Base.helper ListFilter::Helper

class TestController < ActionController::Base
  include ListFilter, ListFilter::Controller, ListFilter::Helper

  def filters
    filter_1 = ListFilter::Filter.new("filter1", "filter 1", "select") { 
      ["name1", "name2"]
    }
    
    filter_2 = ListFilter::Filter.new("filter2", "filter 2", "date") { 
      Date.today 
    }

    [ filter_1, filter_2 ]
  end
end

class ListFilterTest < Test::Unit::TestCase
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::JavaScriptHelper
  include ListFilter::Helper

  def setup
    @controller = TestController.new
    #@request    = ActionController::TestRequest.new
    #@response   = ActionController::TestResponse.new
  end

  def test_filter
    params[:filter_id] = nil

    html = @controller.list_filters params[:filter_id]

    puts html
    # assert_equal
  end

end
