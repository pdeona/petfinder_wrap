module Petfinder
  module JsonMapper
    def json_attributes(*names)
      names.each { |name| json_attribute(name) }
    end

    def json_attribute name
      define_method name do
        if name.include? "_"
          camelName = name.split("_").map { |word| word.capitalize unless word == (name.split("_").first) }.join
          @attributes.dig(camelName, "$t")
        elsif @attributes.dig(name, "$t")
          @attributes.dig(name, "$t")
        else
          @attributes["#{name}"]
        end
      end
    end
  end
end
