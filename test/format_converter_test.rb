require 'test_helper'
require_relative '../lib/importer_exporter/format_converter'

class FormatConverterTest < Minitest::Test
  
  def setup
    # The cwd/pwd is the project root, not the test dir.
    @file_path = "./example.csv"
    @input_type = "product"
    @output_format = "json"
  end
  
  # NON_FUNC_REQ_1, NON_FUNC_REQ_2
  def test_initialize
    converter = ImporterExporter::FormatConverter.new @file_path, @input_type, @output_format
    assert_equal @file_path, converter.input_file_path
    assert_equal "csv", converter.input_format
    assert_equal @input_type, converter.input_type
    assert_equal @output_format, converter.output_format
  end
  
  # FUNC_REQ_1
  def test_format_csv_product_json
    converter = ImporterExporter::FormatConverter.new @file_path, @input_type, @output_format
    converter.format do |json|
      assert_equal String, json.class
      refute_empty json
    end
  end
end
