module AngularConfig
  class File
    attr_reader :path

    def initialize(source_path)
      @path = ::File.expand_path(source_path)
    end

    def content
      ::File.read(path).chomp
    end

    def content=(data)
      ::File.open(path, "w") do |file|
        file.write(data.to_json)
      end
    end
  end
end
