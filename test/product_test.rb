require 'test_helper'
require_relative '../lib/importer_exporter/product'

class ProductTest < Minitest::Test
  
  def setup
    @data = {
      description: "Coffee",
      price: "$3.50",
      cost: "$0.80",
      modifier_1_small: "-$0.70",
      modifier_1_large: "$0.80"
    }
    @hash_data = {
      description: "Coffee",
      price: 3.50,
      cost: 0.80,
      modifiers: [
        { 
          name: "small",
          price: -0.70
        },
        { 
          name: "large",
          price: 0.80
        }
      ],
      total_prices: [2.80, 4.30],
      total_margins: [2.00, 3.50]
    }
  end
  
  def test_initialize
    product = ImporterExporter::Product.new @data
    
    # Assert instance var and getter method creation.
    assert product.respond_to? :description
    assert product.respond_to? :price
    assert product.respond_to? :cost
    
    # Assert price and cost Float values.
    assert_equal 3.50, product.price
    assert_equal 0.80, product.cost
    
    # Assert Modifiers have been init correctly. 
    refute_empty product.modifiers
    assert_equal 2, product.modifiers.count
    
    assert_equal "small", product.modifiers.first.name
    assert_equal(-0.70, product.modifiers.first.price)
    
    assert_equal "large", product.modifiers.last.name
    assert_equal 0.80, product.modifiers.last.price
  end
  
  # ADD_REQ_1
  def test_total_prices
    product = ImporterExporter::Product.new @data
    assert_equal [2.80, 4.30], product.total_prices
  end
  
  # ADD_REQ_1
  def test_total_margins
    product = ImporterExporter::Product.new @data
    assert_equal [2.00, 3.50], product.total_margins
  end
  
  def test_to_h
    product = ImporterExporter::Product.new @data
    assert_equal(@hash_data, product.to_h)
  end
end
