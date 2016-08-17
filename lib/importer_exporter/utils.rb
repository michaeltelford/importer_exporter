
module ImporterExporter
  
  # Utility module containing generic reusable methods.
  module Utils
    
    # Returns a hash created from obj's instance vars and values.
    # Will ignore any variables in ignore or matches from regexes.
    def self.to_h(obj, ignore = [], regexes = [])
      hash = {}
      obj.instance_variables.each do |var|
        next if ignore.include?(var)
        next if regexes.any? { |regex| var[regex] }
        hash[var[1..-1].to_sym] = obj.instance_variable_get(var)
      end
      hash
    end

    # Improved each method which takes care of singleton and enumerable
    # objects. Yields one or more objects.
    def self.each(obj_or_objs)
      if obj_or_objs.respond_to?(:each)
        obj_or_objs.each { |obj| yield obj }
      else
        yield obj_or_objs
      end
    end
    
    # Inits an instance var and getter method for each key value pair in hash. 
    def self.init_from_hash(obj, hash)
      hash.each do |k, v|
        var_name = "@#{k}".gsub(" ", "_")
        obj.instance_variable_set(var_name, v)
        obj.class.send(:define_method, "#{k}".to_sym) do
          obj.instance_variable_get("@#{k}")
        end
      end
    end
    
    # Removes any leading non Float values and returns a Float (0.0 if all chars).
    # Assumes that trailing String chars will not be present.
    def self.remove_leading_chars(value)
      return value if value.is_a? Float
      index = 0
      value.to_s.each_char do |char|
        next if char == "."
        index += 1 if (char =~ /[0-9]/) != 0
      end
      value[index..-1].to_f
    end
    
    def self.round(float, decimal_places)
      ("%.#{decimal_places}f" % float).to_f
    end
  end
end
