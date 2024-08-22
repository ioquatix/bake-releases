# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'bake'

describe Bake::Changes do
	it "has a version number" do
		expect(Bake::Changes::VERSION).to be =~ /^\d+\.\d+\.\d+$/
	end
	
	let(:project_root) {File.expand_path('.project', __dir__)}
	let(:context) {Bake::Context.load(project_root)}
	
	it "can update changes document" do
		changes_path = File.join(project_root, 'changes.md')
		
		File.write(changes_path, <<~DOCUMENT)
			# Changes
			
			## Unreleased
			
			  - Fixed a bug.
			
			## v0.0.0
			
			  - First release.
		DOCUMENT
		
		context['changes:release'].call('1.0.0')
		
		expect(File.read(changes_path)).to be == <<~DOCUMENT
			# Changes
			
			## v1.0.0
			
			  - Fixed a bug.
			
			## v0.0.0
			
			  - First release.
		DOCUMENT
	end
end
