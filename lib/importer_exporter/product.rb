require_relative 'input_type'
require_relative 'modifier'

module ImporterExporter
  
  # Any logic specific to the Product input type should go in this class.
  # Any generic input type logic should go in the InputType (super) class. 
  class Product < InputType
    MODIFIER_PREFIX = "modifier_"
    
    attr_reader :modifiers
    
    # Dynamically create instance vars and getter methods allowing Product 
    # attributes to change in the future without work.
    # data is a Hash instance.
    def initialize(data)
      ImporterExporter::Utils.init_from_hash self, data
  
      # Convert price and cost to a Float value.
      if respond_to? :price
        @price = ImporterExporter::Utils.remove_leading_chars(price)
      end
      if respond_to? :cost
        @cost = ImporterExporter::Utils.remove_leading_chars(cost)
      end
  
      # Init modifiers, removing the modifier prefix of the key.
      @modifiers = []
      data.each do |k, v|
        if k.to_s.start_with?(MODIFIER_PREFIX) and not v.nil?
          key = k.to_s[(MODIFIER_PREFIX.length + 2)..-1]
          @modifiers << ImporterExporter::Modifier.new(key, v)
        end
      end
    end
    
    # ADD_REQ_1
    # Returns an array of possible total prices.
    # Takes into account price and any modifiers.
    # Returns an Array of Float instances.
    def total_prices
      return [] unless respond_to? :price
      return [price] if modifiers.empty?
      
      prices = []
      modifiers.each do |mod|
        prices << mod.apply_modifier(ImporterExporter::Utils.round(price, 2))
      end
      
      prices
    end
    
    # ADD_REQ_1
    # Returns an array of possible total margins.
    # Takes into account the total_price and the cost.
    # Returns an Array of Float instances.
    def total_margins
      return [] unless respond_to? :price and respond_to? :cost
      
      margins = []
      total_prices.each do |price|
        margins << ImporterExporter::Utils.round((price - cost), 2)
      end
      
      margins
    end
    
    # Returns a Hash instance made of product instance vars.
    def to_h
      # We ignore the modifiers array we init and the modifier values form the input. 
      hash = ImporterExporter::Utils.to_h self, [:@modifiers], [/^@#{MODIFIER_PREFIX}/i]
      hash[:modifiers] = []

      # Now we init the modifiers by calling each modifier's to_h method in turn. 
      if not modifiers.empty?
        modifiers.each do |mod|
          hash[:modifiers] << mod.to_h
        end
      end
      
      # Now init the total prices and margins in the Hash.
      hash[:total_prices] = total_prices
      hash[:total_margins] = total_margins
      
      hash
    end
    
    # Aliased to make sense for both 'open' and 'system' products.
    alias_method :current_prices, :total_prices
  end
end
