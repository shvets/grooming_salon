# Copyright (c) 2005 Geoffrey Grosenbach
# Copyright (c) 2007 Marty Haught
# Copyright (c) 2007 Andrew Kappen
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'bigdecimal'

# Extension to make it easy to read and write data to a file.
class ActiveRecord::Base
  class << self

    # Write a fixture file using existing data in the database.
    #
    # Will be written to +db/dataset/table_name.yml+ by default, but +path+ can be 
    # over-ridden. Fixture can be restricted to +limit+ records.
    def to_fixture(path="db/dataset", limit=nil)
      opts = {}
      opts[:limit] = limit if limit

      write_file(File.expand_path("#{path}/#{table_name}.yml", RAILS_ROOT), 
          self.find(:all, opts).inject({}) { |hsh, record| 
              hsh.merge("#{table_name.singularize}_#{'%05i' % record.id}" => record.attributes) 
            }.to_yaml(:SortKeys => true))
      habtm_to_fixture(path)
    end

    private
    
    # Write the habtm association table
    def habtm_to_fixture(path)
      joins = self.reflect_on_all_associations.select { |j|
        j.macro == :has_and_belongs_to_many
      }
      joins.each do |join|
        hsh = {}
        connection.select_all("SELECT * FROM #{join.options[:join_table]}").each_with_index { |record, i|
          hsh["join_#{'%05i' % i}"] = record
        }
        write_file(File.expand_path("#{path}/#{join.options[:join_table]}.yml", RAILS_ROOT), hsh.to_yaml(:SortKeys => true))
      end
    end
  
    def write_file(path, content) # :nodoc:
      f = File.new(path, "w+")
      f.puts content
      f.close
    end
  end
end

# Override the yaml sortkeys bug (http://code.whytheluckystiff.net/syck/ticket/3) using the provided patch
# This is actually the default behavior for older (<=1.8.2) versions of ruby
class Hash
  def to_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      out.map( taguri, to_yaml_style ) do |map|
        sorted_keys = keys
        sorted_keys = begin
          sorted_keys.sort
        rescue
          sorted_keys.sort_by {|k| k.to_s} rescue sorted_keys
        end
        sorted_keys.each do |k|
          map.add( k, fetch(k) )
        end
      end
    end
  end
end

# Fixes output for floats
class BigDecimal
  def to_yaml (opts={},&block)
    to_s.to_yaml(opts,&block)
  end
end