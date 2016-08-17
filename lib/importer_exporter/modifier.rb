require_relative 'utils'

module ImporterExporter
  class Modifier
    
    attr_reader :name, :price, :action
    
    def initialize(name, price)
      @name = name
      # Remove the - and/or the $ (if present) so your left with a Float.
      @price = ImporterExporter::Utils.remove_leading_chars(price)

      if price.start_with? "-"
        @action = :-
      else
        @action = :+
      end
    end
    
    def price
      temp_price = ImporterExporter::Utils.round(@price, 2)
      if @action == :-
        "-#{temp_price}".to_f
      else
        temp_price
      end
    end
    
    # Returns the new product_price having applied the modifier. 
    # Note: this is a new instance of Float. 
    def apply_modifier(product_price)
      product_price.send @action, @price
    end
    
    # Returns a Hash instance made of modifier instance vars.
    def to_h
      hash = ImporterExporter::Utils.to_h self, [:@action]
      hash[:price] = price
      hash
    end
  end
end
