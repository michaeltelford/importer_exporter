require 'test_helper'
require_relative '../lib/importer_exporter/modifier'

class ModifierTest < Minitest::Test
  
  def setup
  end
  
  def test_initialize
    name = "Medium"
    
    # Test negative value with $.
    price = "-$0.25"
    mod = ImporterExporter::Modifier.new name, price
    assert_equal(-0.25, mod.price)
    
    # Test negative value without $.
    price = "-0.25"
    mod = ImporterExporter::Modifier.new name, price
    assert_equal(-0.25, mod.price)
    
    # Test positive value with $.
    price = "$0.25"
    mod = ImporterExporter::Modifier.new name, price
    assert_equal 0.25, mod.price
    
    # Test positive value without $.
    price = "0.25"
    mod = ImporterExporter::Modifier.new name, price
    assert_equal 0.25, mod.price
  end
  
  def test_apply_modifier
    name = "Medium"
    product_price = 7.55
    
    # Test a positive modifier (additive).
    price = "$0.55"
    mod = ImporterExporter::Modifier.new name, price
    assert_equal 8.10, mod.apply_modifier(product_price)
    
    # Test a negative modifier (subtractive).
    price = "-$0.55"
    mod = ImporterExporter::Modifier.new name, price
    assert_equal 7.00, mod.apply_modifier(product_price)
  end
  
  def test_to_h
    name = "Medium"
    price = "-$0.25"
    mod = ImporterExporter::Modifier.new name, price
    assert_equal({
      name: name,
      price: -0.25
    }, mod.to_h)
  end
end
