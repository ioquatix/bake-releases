# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

# Publish a GitHub release for the given version.
#
# Requires a `source_code_uri` or `homepage` pointing to `github.com` in the gemspec.
# Uses the `gh` command-line tool to create the release.
# Release notes are extracted from `releases.md` for the given version; if none are found, the release is created with empty notes.
#
# @parameter tag [String] The tag name of the release, e.g. "v1.2.3".
def release(tag)
	require "tempfile"
	
	repo = github_repo
	notes = release_notes(tag.to_s)
	
	Tempfile.create(["release-notes", ".md"]) do |file|
		file.write(notes || "")
		file.flush
		
		system(
			"gh", "release", "create", tag.to_s,
			"--repo", repo,
			"--title", tag.to_s,
			"--notes-file", file.path,
			"--clobber"
		) or raise "Failed to create GitHub release for #{tag}"
	end
end

private

GITHUB_URI_PATTERN = %r{github\.com[:/]+(?<repo>[^/\s]+/[^/\s]+?)(?:\.git)?$}

def github_repo
	gemspec_path = Dir.glob(File.join(context.root, "*.gemspec")).first
	raise "No gemspec found in #{context.root}" unless gemspec_path
	
	spec = Gem::Specification.load(gemspec_path)
	
	source_uri = spec.metadata&.dig("source_code_uri") || spec.homepage
	raise "No source_code_uri or homepage found in gemspec" unless source_uri
	
	match = GITHUB_URI_PATTERN.match(source_uri)
	raise "URI does not appear to be a GitHub repository: #{source_uri}" unless match
	
	match[:repo]
end

def release_notes(tag, path = File.join(context.root, "releases.md"))
	return nil unless File.exist?(path)
	
	require "markly"
	document = Markly.parse(File.read(path))
	
	header = document.find_header(tag)
	return nil unless header
	
	fragment = Markly::Node.new(:document)
	node = header.next
	while node
		break if node.type == :header && node.header_level <= header.header_level
		next_node = node.next
		fragment.append_child(node)
		node = next_node
	end
	
	return nil unless fragment.first_child
	
	offset = header.header_level - 1
	if offset > 0
		fragment.walk do |node|
			if node.type == :header
				node.header_level -= offset
			end
		end
	end

	fragment.to_markdown.strip
end
