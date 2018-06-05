#!/usr/bin/env ruby

require_relative './base.rb'

class GitReposTracker < TrackerConfigurationBase
  def run
    tracker_repos = %w(
      app_env
      app_env_secret_nonprod
      checkfiles
      gitpflow
      lib-tracker-proxy
      pivotal_ide_prefs
      tracker-android
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
      clone_git_repo('pivotaltracker', repo, "~/go/src/github.com/pivotaltracker/#{repo}")
    end

    clone_git_repo('pivotaltracker', 'tracker', '~/workspace/tracker', 'direnv allow', 'apps/tracker-web')
    clone_git_repo('pivotaltracker', 'tracker', '~/workspace/alt-tracker', 'direnv allow', 'apps/tracker-web')

    clone_git_repo(
      'pivotaltracker',
      'app_env_secret_nonprod',
      '~/.app_env_secret',
      post_clone_command = 'ln -s ~/.app_env_secret/keys/npmrc ~/.npmrc'
    )
  end

  def clone_git_repo(org, repo_name, target_path, post_clone_command = '', post_clone_command_directory = '')
    # Don't clone if it's already there.
    path = File.expand_path(target_path)
    return if Dir.exist?(path)

    puts "Cloning repo: #{org}/#{repo_name} into #{path}"
    process_without_output("git clone git@github.com:#{org}/#{repo_name}.git #{path}")

    unless post_clone_command.empty?
      FileUtils.cd(File.join(path, post_clone_command_directory)) do
        process_without_output(post_clone_command)
      end
    end
  end
end

GitReposTracker.new.run
