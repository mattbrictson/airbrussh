# Adapted from https://github.com/ruby-grape/danger/blob/master/Dangerfile
# Q: What is a Dangerfile, anyway? A: See http://danger.systems/

# ------------------------------------------------------------------------------
# What changed?
# ------------------------------------------------------------------------------
has_lib_changes = !git.modified_files.grep(/^lib/).empty?
has_test_changes = !git.modified_files.grep(/^test/).empty?
has_changelog_changes = git.modified_files.include?("CHANGELOG.md")

# ------------------------------------------------------------------------------
# You've made changes to lib, but didn't write any tests?
# ------------------------------------------------------------------------------
if has_lib_changes && !has_test_changes
  warn("There are code changes, but no corresponding tests. "\
       "Please include tests if this PR introduces any modifications in "\
       "Airbrussh's behavior.",
       :sticky => false)
end

# ------------------------------------------------------------------------------
# Have you updated CHANGELOG.md?
# ------------------------------------------------------------------------------
if !has_changelog_changes && has_lib_changes
  pr_number = github.pr_json["number"]
  markdown <<-MARKDOWN
Here's an example of a CHANGELOG.md entry (place it immediately under the `* Your contribution here!` line):

```markdown
* [##{pr_number}](https://github.com/mattbrictson/airbrussh/pull/#{pr_number}): #{github.pr_title} - [@#{github.pr_author}](https://github.com/#{github.pr_author}).
```
MARKDOWN
  warn("Please update CHANGELOG.md with a description of your changes. "\
       "If this PR is not a user-facing change (e.g. just refactoring), "\
       "you can disregard this.", :sticky => false)
end

# ------------------------------------------------------------------------------
# Did you remove the CHANGELOG's "Your contribution here!" line?
# ------------------------------------------------------------------------------
if has_changelog_changes
  unless IO.read("CHANGELOG.md") =~ /^\* Your contribution here/i
    fail(
      "Please put the `* Your contribution here!` line back into CHANGELOG.md.",
      :sticky => false
    )
  end
end
