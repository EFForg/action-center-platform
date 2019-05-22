# Monkeypatch for paperclip to continue working post Rails 5 fileupload changes
#
# Without this, the following error occurs when trying to change the image
# attached to a particular record:
#   Content Type Spoof: Filename img_file.png (binary/octet-stream from Headers,
#   ["image/png"] from Extension), content type discovered from file command: image/png.
#
# Additionally, this only allows paperclip to interact with image files
#
# The class we're patching is here: https://github.com/thoughtbot/paperclip/blob/fbdcbe8da30138dac5500e4291e7b279491d1316/lib/paperclip/media_type_spoof_detector.rb

module MonkeyPatches
  module OctetStreamOverride
    def spoofed?
      return true unless is_image?
      override_header_type if supplied_content_type == "binary/octet-stream"
      if has_name? && has_extension? && media_type_mismatch? && mapping_override_mismatch?
        Paperclip.log("Content Type Spoof: Filename #{File.basename(@name)} (#{supplied_content_type} from Headers, #{content_types_from_name.map(&:to_s)} from Extension), content type discovered from file command: #{calculated_content_type}. See documentation to allow this combination.")
        true
      else
        false
      end
    end

    private

    def is_image?
      return true if /\Aimage\/.*\Z/.match? calculated_content_type
      Paperclip.log("Attempted non-image upload: Filename #{File.basename(@name)} (#{supplied_content_type}")
      false
    end

    def override_header_type
      @content_type = calculated_content_type
    end
  end
end
