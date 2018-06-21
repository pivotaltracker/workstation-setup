#!/usr/bin/env ruby

require_relative './base.rb'

class UnixTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    things = %w(
      ack
      automake
      awscli
      bash
      carthage
      cloudfoundry/tap/cf-cli
      cmake
      coreutils
      ctags
      diff-so-fancy
      direnv
      dirmngr
      docbook-xsl
      ghostscript
      git
      git-duet/tap/git-duet
      glide
      gnupg
      gpg-agent
      gradle
      haproxy
      htop
      httpie
      hub
      icu4c
      imagemagick
      ios-sim
      jid
      jmeter
      jq
      jsonpp
      lastpass-cli
      libusb-compat
      maven
      memcached
      mogenerator
      mysql@5.7
      neovim
      parallel
      phantomjs
      proctools
      pstree
      qt
      redis
      s3cmd
      shellcheck
      solr@6.6
      ssh-copy-id
      sshuttle
      the_platinum_searcher
      ripgrep
      tig
      tmux
      tree
      vim
      watch
      wget
      yarn
      zlib
    )

    process("brew tap pivotaltracker/homebrew-tracker")

    things.each do |thing|
      brew_install(thing)
    end

    # Copy .vimrc file
    FileUtils.copy("#{repo_root}/files/tracker/.vimrc", "#{home}/.vimrc")
  end
end

UnixTracker.new.run
