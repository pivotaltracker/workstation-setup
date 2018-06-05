#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureGitAliasesTracker < TrackerConfigurationBase
  def run
    # Default to using duet
    create_git_alias('ci', 'duet-commit')
    create_git_alias('dci', 'duet-commit')
    create_git_alias('mg', 'duet-merge')
    create_git_alias('dmg', 'duet-merge')

    # Add other Tracker-specific aliases
    create_git_alias('dsff', '!f() { [ "" != "" ] && cd ; git diff --color  | diff-so-fancy | less --tabs=4 -RFX; }; f')
    create_git_alias('bdr', "for-each-ref --sort=-committerdate refs/remotes/ --format='%(committerdate:short) %1B[0;31m%(refname:short)%1B[m'")
    create_git_alias('bdl', "for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %1B[0;31m%(refname:short)%1B[m'")
    create_git_alias('please', 'push --force-with-lease')
  end

  def create_git_alias(name, command)
    process_without_output("git config --global alias.#{name} \"#{command}\"")
  end
end

ConfigureGitAliasesTracker.new.run
