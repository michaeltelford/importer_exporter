require "./lib/importer_exporter"

error_msg = "Incorrect options given, please provide 
- input_type
- input_type
- output_format
e.g.
ruby main.rb ./example.csv product json"
output_file_path = "./example.json"

# Get user args.
options = ARGV.dup
puts error_msg and return unless options.length == 3

# Do the conversion and write the output to a file. 
converter = ImporterExporter::FormatConverter.new options[0], options[1], options[2]
converter.format do |json|
  File.delete output_file_path if File.exist? output_file_path
  File.open output_file_path, "w+" do |file|
    file.puts json
  end
end
