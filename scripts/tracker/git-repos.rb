#!/usr/bin/env ruby

require_relative './base.rb'

class GitReposTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
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
      clone_git_repo('pivotaltracker', repo, "~/workspace/#{repo}")
    end

    go_repos = %w(gogator gusher)
    go_repos.each do |repo|
      clone_git_repo('pivotaltracker', repo, path = "~/go/src/github.com/pivotaltracker/#{repo}")
    end

    direnv_allow_repos = %w(tracker tracker-concourse)
    direnv_allow_repos.each do |repo|
      clone_git_repo('pivotaltracker', repo, "~/workspace/#{repo}", post_clone_command = 'direnv allow')
    end

    clone_git_repo('pivotaltracker', 'tracker', '~/workspace/alt-tracker', post_clone_command = 'direnv allow')

    clone_git_repo(
      'pivotaltracker',
      'app_env_secret_nonprod',
      '~/.app_env_secret',
      post_clone_command = 'ln -s ~/.app_env_secret/keys/npmrc ~/.npmrc'
    )
  end

  def clone_git_repo(org, repo_name, target_path, post_clone_command = '')
    # Don't clone if it's already there.
    path = File.expand_path(target_path)
    return if Dir.exist?(path)

    puts "Cloning repo: #{org}/#{repo_name} into #{path}"
    process("git clone git@github.com:#{org}/#{repo_name}.git #{path}", puts_output: :error)

    unless post_clone_command.empty?
      FileUtils.cd(path) do
        process(post_clone_command)
      end
    end
  end
end

GitReposTracker.new.run
