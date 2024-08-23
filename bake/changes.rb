# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

# Update the 'Unreleased' section of the changes document with the given version number, if it exists.
#
# The version number can be any string, but ideally follows the semantic versioning scheme with a "v" prefix.
#
# @parameter version [String] The version number to release.
def release(version)
	self.update_document do |document|
		if node = document.find_header('Unreleased')
			# Create a new text node with the version number:
			child = Markly::Node.new(:text)
			child.string_content = version.to_s
			
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

def update_document(path = self.changes_path)
	require 'markly'
	
	if File.exist?(path)
		document = Markly.parse(File.read(path))
		
		yield document
		
		File.write(path, document.to_markdown)
	end
end
