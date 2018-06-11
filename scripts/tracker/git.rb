#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureGitTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    # Add Tracker .git-authors
    FileUtils.copy("#{repo_root}/files/tracker/.git-authors", "#{home}/.git-authors")

    # Do the Tracker-specific Git configuration
    set_git_config('pull.rebase', 'preserve')
    set_git_config('push.default', 'current')
    set_git_config('user.email', 'labs-tracker-team@pivotal.io')
    set_git_config('user.name', 'Pivotal Tracker')

    tracker_repos = %w(
      app_env
      app_env_secret_nonprod
      checkfiles
      gitpflow
      lib-tracker-proxy
      tracker-android
      tracker-docs
      tracker-ios
      tracker-knowledge-base
      tracker-marketing
      tracker-vcr
    )
    tracker_repos.each do |repo|
      clone_git_repo('pivotaltracker', repo)
    end

    go_repos = %w(gogator gusher titan)
    go_repos.each do |repo|
      clone_git_repo('pivotaltracker', repo, path='~/go/src/github.com/pivotaltracker')
    end

    direnv_allow_repos = %w(tracker tracker-concourse)
    direnv_allow_repos.each do |repo|
      clone_git_repo('pivotaltracker', repo, direnv=true)
    end

    clone_git_repo('pivotaltracker', 'tracker', path='~/workspace/alt-tracker', direnv=true)

    clone_git_repo(
      'pivotaltracker',
      'app_env_secret_nonprod',
      path='~/.app_env_secret',
      post_clone_command='ln -s ~/.app_env_secret/keys/npmrc ~/.npmrc'
    )
  end

  def set_git_config(key, value)
    process("git config --global '#{key}' '#{value}'")
  end

  def clone_git_repo(org, repo_name, path='~/workspace', direnv=false, post_clone_command='')
    process("git clone git@github.com:#{org}/#{repo_name}.git #{path}/#{repo_name}")
    if direnv
      FileUtils.cd(repo_root) do
        process("direnv allow")
      end
    end

    if post_clone_command != ''
      FileUtils.cd(path) do
        process(post_clone_command)
      end
    end
  end
end

ConfigureGitTracker.new.run
