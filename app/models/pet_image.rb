#

class PetImage < ActiveRecord::Base
  belongs_to :pet

  validates_format_of :content_type, 
                      :with => /^image/,
                      :message => "--- you can only upload pictures"

  def uploaded_image=(incoming_file)
    self.filename     = base_part_of(incoming_file.original_filename)
    self.content_type = incoming_file.content_type #.chomp

    # may be a string or a stringio
#    if incoming_file.respond_to?(:rewind)
#      incoming_file.rewind
#      self.data = incoming_file.read
#    else
#      self.data = incoming_file
#    end
#    self.data         = incoming_file.read
  end

  def filename=(new_filename)
    write_attribute("filename", sanitize_filename(new_filename))
  end
 
  private

  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end

  def sanitize_filename(filename)
    #get only the filename, not the whole path (from IE)
    just_filename = File.basename(filename)
    #replace all non-alphanumeric, underscore or periods with underscores
    just_filename.gsub(/[^\w\.\-]/, '_')
  end

end
