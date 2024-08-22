# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

def release(version)
	path = self.changes_path
	
	unless version.start_with?('v')
		version = "v#{version}"
	end
	
	self.update_document(path) do |document|
		if node = document.find_header('Unreleased')
			# Create a new text node with the version number:
			child = Markly::Node.new(:text)
			child.string_content = version
			
			# Delete all current children, and replace it with the version number:
			node.extract_children
			node.append_child(child)
		end
	end
end

private

def changes_path(root = context.root)
	File.join(root, 'changes.md')
end

def update_document(path)
	require 'markly'
	
	if File.exist?(path)
		document = Markly.parse(File.read(path))
		
		yield document
		
		File.write(path, document.to_markdown)
	end
end