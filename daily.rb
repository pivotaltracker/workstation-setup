#!/usr/bin/env ruby

require 'fileutils'
require_relative 'scripts/tracker/base'

class Daily < TrackerConfigurationBase
  def run
    update_workstation_setup unless ENV['ALLOW_DIRTY_REPO']
    process_without_output("#{repo_root}/scripts/tracker/git.rb")
    process_without_output("#{repo_root}/scripts/tracker/configuration-bash.rb")
    process_without_output('ssh-add -D')
    FileUtils.rm_f("#{home}/.config/hub")

    # because launchd doesn't like it if a script takes under 10 seconds
    # https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html
    sleep 10
  end

  private

  def update_workstation_setup
    FileUtils.cd(repo_root) do
      verify_clean_git
      process_without_output('git checkout master')
      process_without_output('git pull --rebase')
    end
  end

  def verify_clean_git
    begin
      process_without_output("cd #{repo_root} && git status | grep -E '(to be committed|not staged|untracked)'", expected_exit_status: 1, out: :never)
    rescue ProcessHelper::UnexpectedExitStatusError
      STDERR.puts "\nERROR: Refusing to run daily workstation-setup because there are uncommitted, unstaged or untracked git changes in #{repo_root}."
      exit 1
    end
  end
end

Daily.new.run

