require 'CSV'
require 'json'

module ImporterExporter
  class FormatConverter
    
    attr_reader :input_file_path, :input_format, :input_type, :output_format
    
    # Parameters are as follows:
    # - input_file_path: The file path containing the data to be converted.
    # - input_type: The type or entity that each instance of input data 
    # represents e.g. Product, Customer or Transaction. 
    # - output_format: The end result of the data conversion e.g. JSON. 
    # All parameters are required and the input_file_path must have a valid 
    # file extension e.g. example.csv
    def initialize(input_file_path, input_type, output_format)
      @input_file_path = input_file_path
      @input_format = input_file_path.split(".").last.strip.downcase
      @input_type = input_type
      @output_format = output_format
      @hash_data = []
    end
    
    # FUNC_REQ_1
    # Returns a String instance of type @output_format e.g. JSON.
    def format(&block)
      process_input_format
      process_output_format(&block)
    end
    
    private
    
    # NON_FUNC_REQ_1
    # Returns a Hash instance.
    def process_input_format
      # Extend this case block to support other input formats e.g. txt. 
      case @input_format.strip.downcase
      when "csv"
        process_input_csv
      else
        raise "input format not supported: #{@input_format}"
      end
    end
    
    # NON_FUNC_REQ_2
    # Takes an input instance e.g. Person or Transaction etc.
    def process_input_type(row_of_input)
      # Extend this case block to support other input types e.g. Customer.
      case @input_type.strip.downcase
      when "product"
        process_type_product row_of_input
      else
        raise "input type not supported: #{@input_type}"
      end
    end
    
    # NON_FUNC_REQ_1
    # Returns a String instance of type @output_format e.g. JSON.
    # Also yield to a given block passing in the output data. 
    def process_output_format(&block)
      output_data = ""
      
      # Extend this case block to support other output formats e.g. xml.
      case @output_format.strip.downcase
      when "json"
        output_data = process_output_json
      else
        raise "input type not supported: #{@output_format}"
      end
      
      block.call(output_data) if block_given?
      output_data
    end
    
    # Pulls out each row of input data e.g. each Product or Customer and passes 
    # it to be processed by the given input type logic. Any other process_ methods 
    # supporting other formats should do the same.  
    # The @columns instance var should be set by this method before any input type 
    # processing. 
    def process_input_csv
      index = 0
      CSV.foreach(@input_file_path) do |row_of_input|
        index += 1
        if index == 1
          @columns = row_of_input
          next
        end
        @hash_data << process_input_type(row_of_input)
      end
    end
    
    # Take a row of input (Array instance) and converts it into a Hash 
    # representing a Product.
    def process_type_product(row_of_input)
      hash = {}
      mod_prefix = ImporterExporter::Product::MODIFIER_PREFIX
      
      @columns.each_with_index do |column, i|
        column.strip!
        column = column.split(" ").last # id instead of item id
        value = row_of_input[i]
        next unless value
        
        if column.start_with?(mod_prefix) and value
          key = column[(mod_prefix.length + 2)..-1]
          # Process name and price together skipping the next column interation (price).
          if key.downcase.include? "name"
            hash[(column[0..-5] + value).to_sym] = row_of_input[i + 1]
          end
        else
          hash[column.to_sym] = value
        end
      end
      
      ImporterExporter::Product.new(hash).to_h
    end
    
    def process_output_json
      @hash_data.to_json
    end
  end
end
