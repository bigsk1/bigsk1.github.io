# frozen_string_literal: true

require "date"
require "yaml"
require "fileutils"
require "pathname"

ENV["TZ"] = "America/Los_Angeles"
ROOT = Pathname.new(__dir__).parent.realpath
SLUG = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/
FILENAME = /\A\d{4}-\d{2}-\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*\.md\z/

def fail_with(message)
  abort message
end

def help
  puts 'Usage: bash tools/new-post.sh "Title" [slug]'
  puts '       bash tools/publish-post.sh _drafts/YYYY-MM-DD-slug.md'
end

def write_new(path, content)
  File.open(path, File::WRONLY | File::CREAT | File::EXCL, 0o644) { |file| file.write(content) }
end

begin
action = ARGV.shift
if ARGV == ["--help"] || ARGV == ["-h"]
  help
  exit
end

case action
when "new"
  fail_with('Supply a title and optional slug. See --help.') unless (1..2).cover?(ARGV.length)
  title = ARGV[0].strip
  fail_with("Title cannot be empty or contain newlines.") if title.empty? || title.match?(/[\r\n]/)
  slug = ARGV[1] || title.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|\-\z/, "")
  fail_with("Use a lowercase slug with letters, numbers, and single hyphens.") unless SLUG.match?(slug)
  existing = %w[_posts _drafts].flat_map { |dir| ROOT.join(dir).glob("*-#{slug}.md") }
  fail_with("A post with this URL already exists: #{existing.join(', ')}") unless existing.empty?
  now = Time.now
  data = {
    "title" => title, "date" => now.strftime("%Y-%m-%d %H:%M:%S %z"),
    "description" => "TODO: Write a concise description.",
    "categories" => ["Technology"], "tags" => [], "toc" => true,
    "published" => false
  }
  path = ROOT.join("_drafts", "#{now.strftime('%Y-%m-%d')}-#{slug}.md")
  FileUtils.mkdir_p(path.parent)
  content = data.to_yaml + "# Optional local cover image:\n# image:\n#   path: /assets/images/headers/#{slug}.webp\n#   alt: Describe the image.\n---\n\nTODO: Write the introduction.\n\n## Getting started\n\nTODO: Add researched, verified content.\n"
  write_new(path, content)
  puts "Created #{path.relative_path_from(ROOT)}"
  puts "Preview: bash tools/run.sh --drafts"
when "publish"
  fail_with("Supply one draft path. See --help.") unless ARGV.length == 1
  path = Pathname.new(ARGV[0]).expand_path(ROOT)
  fail_with("Draft must be a regular file directly inside _drafts/.") unless path.file? && !path.symlink? && path.parent.realpath == ROOT.join("_drafts").realpath
  fail_with("Draft filename must be YYYY-MM-DD-slug.md.") unless FILENAME.match?(path.basename.to_s)
  content = path.read
  match = content.match(/\A---\s*\n(.*?)\n---\s*\n(.*)\z/m)
  fail_with("Draft needs YAML front matter.") unless match
  data = YAML.safe_load(match[1], permitted_classes: [Date, Time])
  fail_with("Draft front matter must be a mapping.") unless data.is_a?(Hash)
  %w[title description date].each do |key|
    fail_with("Fill in #{key} before publishing.") if data[key].to_s.strip.empty?
  end
  %w[categories tags].each do |key|
    fail_with("Choose at least one #{key} value.") unless data[key].is_a?(Array) && data[key].any? { |value| !value.to_s.strip.empty? }
  end
  fail_with("Remove TODO placeholders before publishing.") if content.match?(/\bTODO\b/)
  fail_with("Write the post body before publishing.") if match[2].strip.empty?
  fail_with("Expected published: false in the draft.") unless data["published"] == false
  filename_date, slug = path.basename.to_s.match(/\A(\d{4}-\d{2}-\d{2})-(.*)\.md\z/).captures
  fail_with("Filename date must match the front-matter date.") unless Date.iso8601(filename_date) == DateTime.parse(data["date"].to_s).to_date
  fail_with("Post date is in the future; choose its actual publication time.") if DateTime.parse(data["date"].to_s) > DateTime.now
  existing = ROOT.join("_posts").glob("*-#{slug}.md")
  fail_with("A published post already uses this URL: #{existing.join(', ')}") unless existing.empty?
  destination = ROOT.join("_posts", path.basename)
  updated_front_matter = match[1].sub(/^published: false\s*$/, "published: true")
  fail_with("Use an explicit published: false line.") if updated_front_matter == match[1]
  updated = "---\n#{updated_front_matter}\n---\n#{match[2]}"
  write_new(destination, updated)
  path.delete
  puts "Prepared #{destination.relative_path_from(ROOT)}"
  puts "Validate: bash tools/test.sh"
  puts "Review the post and its images, then commit and push when ready."
else
  help
  exit 1
end
rescue ArgumentError, Psych::Exception, Errno::ENOENT, Errno::EEXIST => error
  fail_with(error.message)
end
