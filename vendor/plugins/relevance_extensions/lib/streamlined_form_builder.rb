#---
# Excerpted from "Agile Web Development with Rails, 2nd Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails2 for more book information.
#---
module Streamlined
  class TabularFormBuilder < ActionView::Helpers::FormBuilder
    (field_helpers - %w(hidden_field)).each do |selector|
      src = <<-END_SRC
        def #{selector}(field, *args, &proc)
          "<tr>" +
            "<td><label for='\#{field}'>\#{field.to_s.humanize}:</label></td>" +
            "<td>" + super + "</td>" +
          "</tr>"
        end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end
    def submit_tag(value)
      "<tr>"+
        "<td>&nbsp;</td>"+
        "<td><input name='commit' type='submit' value='#{value}'/></td>"+
      "</tr>"
    end
  end
  module FormHelpers
    def streamlined_form_for(name, object, options, &proc)
      concat("<table>", proc.binding)
      form_for(name, object, options.merge(:builder => TabularFormBuilder), &proc)
      concat("</table>", proc.binding)
    end
  end
end
ActionView::Base.class_eval do
  include Streamlined::FormHelpers
end
