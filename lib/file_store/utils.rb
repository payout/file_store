module FileStore
  module Utils
    class << self
      def generate_ext_if_needed(file_name)
        File.extname(file_name).length > 0 ? '' : '.dat'
      end
    end # Class Methods
  end # Utils
end # FileStore
