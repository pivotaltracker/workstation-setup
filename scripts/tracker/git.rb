#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureGitTracker < TrackerConfigurationBase
  def run
    # Add Tracker .git-authors
    FileUtils.copy("#{repo_root}/files/tracker/.git-authors", "#{home}/.git-authors")

    # Do the Tracker-specific Git configuration
    set_git_config('pull.rebase', 'preserve')
    set_git_config('push.default', 'current')
    set_git_config('user.email', 'labs-tracker-team@pivotal.io')
    set_git_config('user.name', 'Pivotal Tracker')
    process_without_output('git config --global --unset transfer.fsckobjects', expected_exit_status: [0, 5])
    set_git_config('fsck.zeroPaddedFilemode', 'ignore')

    # Load in the known hosts (note we cannot copy from files/tracker/.ssh
    # because of permissions and we don't want to override)
    FileUtils.mkdir_p("#{home}/.ssh", mode: 0700)
    known_hosts = "#{home}/.ssh/known_hosts"
    FileUtils.touch(known_hosts)
    FileUtils.chmod(0600, known_hosts)
    File.readlines("#{repo_root}/files/tracker/.ssh/known_hosts").each do |line|
      host_matched = File.readlines(known_hosts).any? do |known_host|
        known_host == line
      end
      unless host_matched
        File.open(known_hosts, 'a') do |file|
          file.puts(line)
        end
      end
    end
  end

  def set_git_config(key, value)
    process_without_output("git config --global '#{key}' '#{value}'")
  end
end

ConfigureGitTracker.new.run
