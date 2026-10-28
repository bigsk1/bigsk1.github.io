# frozen_string_literal: true

# Fail the build if local authoring material could be deployed.
require "pathname"

root = Pathname.new(ARGV.fetch(0, "_site"))
abort "Build output missing: #{root}" unless root.directory?
forbidden = root.glob("**/*", File::FNM_DOTMATCH).select do |path|
  parts = path.relative_path_from(root).each_filename.to_a
  private_root = %w[personal _drafts .git .bundle vendor tools _site-preview].include?(parts.first)
  private_root || parts.any? { |part| part == "AGENTS.md" || part == ".env" || part.start_with?(".env.") || part.include?(":Zone.Identifier") }
end
abort "Private/build files in output:\n#{forbidden.join("\n")}" unless forbidden.empty?
puts "Output check passed: no private authoring files or draft sources."
