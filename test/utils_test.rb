require "minitest/autorun"
require_relative "test_helper"
require_relative "../lib/importer_exporter/utils"

# We use a class rather than a Struct because a Struct instance doesn't
# have instance_variables which Utils.to_h uses. 
class Person
    attr_accessor :name, :age, :height
    def initialize
        @name = "Bob"
        @age = 45
        @height = "5'11"
    end
end

class UtilsTest < Minitest::Test
    
  # Runs before every test.
  def setup
    @person = Person.new
    @to_h_result = {
      name: "Bob",
      age: 45
    }
  end
  
  def test_to_h
    # Test with ignore vars.
    h = ImporterExporter::Utils.to_h @person, [:@height]
    assert_equal @to_h_result, h
    
    # Test with ignore regexes.
    h = ImporterExporter::Utils.to_h @person, [], [/^@hei/i]
    assert_equal @to_h_result, h
  end
  
  def test_each
    str = ["hello", "goodbye"]
    ImporterExporter::Utils.each(str) { |el| el.replace(el + 1.to_s) }
    assert_equal ["hello1", "goodbye1"], str
    
    str = "hello"
    ImporterExporter::Utils.each(str) { |el| el.replace(el + 1.to_s) }
    assert_equal "hello1", str
  end
  
  def test_init_from_hash
    obj = Object.new
    ImporterExporter::Utils.init_from_hash obj, @to_h_result
    
    # Test the instance vars get created.
    refute_nil obj.instance_variable_get("@name")
    refute_nil obj.instance_variable_get("@age")
    
    # Test the getter methods get created. 
    assert obj.respond_to?(:name)
    assert_equal "Bob", obj.name
    assert obj.respond_to?(:age)
    assert_equal 45, obj.age
  end
  
  def test_remove_leading_chars
    # Test Float.
    value = 2.35
    result = ImporterExporter::Utils.remove_leading_chars value
    assert result.is_a? Float
    assert_equal value, result
    
    # Test String with no leading chars.
    value = "2.35"
    result = ImporterExporter::Utils.remove_leading_chars value
    assert result.is_a? Float
    assert_equal 2.35, result
    
    # Test String with leading chars.
    value = "-$2.35"
    result = ImporterExporter::Utils.remove_leading_chars value
    assert result.is_a? Float
    assert_equal 2.35, result
    
    # Test with only chars in String. 
    value = "hello"
    result = ImporterExporter::Utils.remove_leading_chars value
    assert result.is_a? Float
    assert_equal 0.00, result
  end
  
  def test_round
    assert_equal 2.0, ImporterExporter::Utils.round(1.98888, 1)
  end
end
