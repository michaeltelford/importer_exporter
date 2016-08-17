require 'test_helper'

class ImporterExporterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ImporterExporter::VERSION
  end
end
