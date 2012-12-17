#-*- coding: utf-8 -*-

require "twitter"
require "tweetstream"
require "oauth"
require "curses"
require "readline"
require "singleton"
require "yaml"
require "json"
require "uri"
require "cgi"

lib_path = File.expand_path('../bird-strike', __FILE__)
require "#{lib_path}/core.rb"
require "#{lib_path}/extend.rb"
require "#{lib_path}/colorizer.rb"
require "#{lib_path}/prompt.rb"
require "#{lib_path}/title-window.rb"
require "#{lib_path}/timeline.rb"
require "#{lib_path}/authorize.rb"
require "#{lib_path}/file-io.rb"
