#-*- coding: utf-8 -*-

require "twitter"
require "tweetstream"
#require "twitter_oauth"
require "oauth"
require "ncurses"
require "readline"
require "yaml"
require "json"
require "uri"
require "cgi"

lib_path = File.expand_path('../bird-strike', __FILE__)
require "#{lib_path}/core.rb"
require "#{lib_path}/extend.rb"
require "#{lib_path}/window.rb"
require "#{lib_path}/file-io.rb"
require "#{lib_path}/twitter.rb"
require "#{lib_path}/input.rb"
