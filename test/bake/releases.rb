# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'bake'

describe Bake::Releases do
	it "has a version number" do
		expect(Bake::Releases::VERSION).to be =~ /^\d+\.\d+\.\d+$/
	end
	
	let(:project_root) {File.expand_path('.project', __dir__)}
	let(:context) {Bake::Context.load(project_root)}
	
	it "can update releases document" do
		releases_path = File.join(project_root, 'releases.md')
		
		File.write(releases_path, <<~DOCUMENT)
			# Releases
			
			## Unreleased
			
			  - Fixed a bug.
			
			## v0.0.0
			
			  - First release.
		DOCUMENT
		
		context['releases:update'].call('v1.0.0')
		
		expect(File.read(releases_path)).to be == <<~DOCUMENT
			# Releases
			
			## v1.0.0
			
			  - Fixed a bug.
			
			## v0.0.0
			
			  - First release.
		DOCUMENT
	ensure
		File.unlink(releases_path)
	end
end
