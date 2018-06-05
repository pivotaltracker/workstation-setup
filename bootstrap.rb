#!/usr/bin/env ruby

require 'stringio'
require 'open3'
require 'fileutils'
require 'timeout'

class BootstrapWorkstationSetup
  def run
    sudoers_admin_nopasswd
    bootstrap_process_helper
    install_command_line_tools
    clone_or_pull_repo
  end

  private

  def sudoers_admin_nopasswd
    process_lite(%q(sudo bash -c "echo '%admin		ALL = (ALL) NOPASSWD: ALL' > /etc/sudoers.d/admin_nopasswd"))
  end

  def bootstrap_process_helper
    need_to_install_in_system_ruby = false
    output, exitstatus = process_lite('gem install process_helper', raise_on_error: false)

    if exitstatus == 1 && output =~ /permission/i
      need_to_install_in_system_ruby = true
    end

    if need_to_install_in_system_ruby
      # system ruby detected, installing process_helper via sudo...
      # TODO: `unalias gem` MAY be needed, not sure yet
      process_lite('sudo gem install process_helper')
    end

    Gem.clear_paths
    require 'process_helper'
    self.class.send(:include, ProcessHelper)
  end

  def install_command_line_tools
    unless File.exist?('/Library/Developer/CommandLineTools')
      # fake that an install is in progress
      process('touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress')

      # list available software
      available_software = process("softwareupdate -l")

      # Get the last (should be latest version) entry for Command Line Tools
      software_name = available_software.split("\n")
        .reverse
        .detect {|line| line =~ /\* Command Line Tools/}
        .match(/.*?(Command Line Tools.*)$/)[1]

      # ...then install it
      process("softwareupdate -i '#{software_name}' --verbose")
    end
  end

  def clone_or_pull_repo
    FileUtils.mkdir_p("#{home}/workspace")
    if File.exist?(repo_root)
      FileUtils.cd(repo_root) do
        verify_clean_git
        process("git checkout master")
        process("git pull --rebase")
      end
    else
      process("git clone https://github.com/pivotaltracker/workstation-setup.git #{home}/workspace/workstation-setup")
    end
  end

  def verify_clean_git
    begin
      process("cd #{repo_root} && git status | grep -E '(to be committed|not staged|untracked)'", expected_exit_status: 1, out: :never)
    rescue ProcessHelper::UnexpectedExitStatusError
      STDERR.puts "\nERROR: There are uncommitted, unstaged or untracked git changes in #{repo_root}.  Please do a `git status` and resolve them, then start over."
      exit 1
    end
  end

  def home
    ENV.fetch('HOME')
  end

  def repo_root
    "#{home}/workspace/workstation-setup"
  end

  def process_lite(cmd, raise_on_error: true, log: false, timeout: 10)
    # A minimal implementation of what ProcessHelper does to use before it's installed
    puts cmd if log
    Open3.popen2e(cmd) do |_, stdout_and_stderr, wait_thr|
      exitstatus = nil
      begin
        Timeout.timeout(timeout) do
          exitstatus = wait_thr.value.exitstatus
        end
      rescue TimeoutError
        wait_thr.kill
        raise "Timeout trying to execute command: #{cmd}"
      end
      output = stdout_and_stderr.readlines.join
      raise output if exitstatus != 0 && raise_on_error
      return [output, exitstatus]
    end
  end
end

BootstrapWorkstationSetup.new.run
