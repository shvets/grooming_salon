#

require 'pdf/writer'

module ActionView # :nodoc:
  class PDFRender
    PAPER = 'A4'
    include ApplicationHelper

    def initialize(action_view)
      @action_view = action_view
    end

    # Render the PDF
    def render(template, local_assigns = {})
      @action_view.controller.headers["Content-Type"] ||= 'application/pdf'
      @action_view.controller.headers["Content-Disposition"] ||= 'attachment'


      #support to pdf on SSL for IE6
      @action_view.controller.headers["Cache-Control"] = 'maxage=3600' 
      @action_view.controller.headers["Pragma"] = 'public' 
      #end of support to pdf on SSL for IE6

      # Retrieve controller variables
      @action_view.controller.instance_variables.each do |v|
        instance_variable_set(v, @action_view.controller.instance_variable_get(v))
      end

      pdf = ::PDF::Writer.new( :paper => PAPER )
      pdf.compressed = true if RAILS_ENV != 'development'
      eval template, nil, "#{@action_view.base_path}/#{@action_view.first_render}.#{@action_view.pick_template_extension(@action_view.first_render)}"

      pdf.render
    end
  end
end
