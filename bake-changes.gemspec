# frozen_string_literal: true

require_relative "lib/bake/changes/version"

Gem::Specification.new do |spec|
	spec.name = "bake-changes"
	spec.version = Bake::Changes::VERSION
	
	spec.summary = "Changes document management."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/ioquatix/bake-changes"
	
	spec.metadata = {
		"documentation_uri" => "https://ioquatix.github.io/bake-changes/",
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
		"source_code_uri" => "https://github.com/ioquatix/bake-changes.git",
	}
	
	spec.files = Dir.glob(['{bake,lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "bake", "~> 0.21"
	spec.add_dependency "markly", "~> 0.8"
end
