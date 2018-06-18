#!/usr/bin/env ruby

require 'fileutils'
require_relative 'scripts/tracker/base'

class Daily < TrackerConfigurationBase
  include ProcessHelper

  def run
    update_workstation_setup
    process("#{repo_root}/scripts/tracker/git.rb")
    process("#{repo_root}/scripts/tracker/configuration-bash.rb")
    process('ssh-add -D')
    FileUtils.rm_f("#{home}/.config/hub")
  end

  private

  def update_workstation_setup
    FileUtils.cd(repo_root) do
      verify_clean_git
      process('git checkout master')
      process('git pull --rebase')
    end
  end

  def verify_clean_git
    begin
      process("cd #{repo_root} && git status | grep -E '(to be committed|not staged|untracked)'", expected_exit_status: 1, out: :never)
    rescue ProcessHelper::UnexpectedExitStatusError
      STDERR.puts "\nERROR: Refusing to run daily workstation-setup because there are uncommitted, unstaged or untracked git changes in #{repo_root}."
      exit 1
    end
  end
end

Daily.new.run

