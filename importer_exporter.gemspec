# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'importer_exporter/version'

Gem::Specification.new do |spec|
  spec.name          = "importer_exporter"
  spec.version       = ImporterExporter::VERSION
  spec.authors       = ["Michael Telford"]
  spec.email         = ["michael.telford@live.com"]

  spec.summary       = "Import export tool used to convert from one format to another."
  spec.description   = "Import export tool used to convert from one format to another."
  spec.homepage      = "https://bitbucket.org/micky_t/importer_exporter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
