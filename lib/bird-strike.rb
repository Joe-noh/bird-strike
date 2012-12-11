#-*- coding: utf-8 -*-

require "twitter"
require "tweetstream"
require "oauth"
require "curses"
require "readline"
require "yaml"
require "json"
require "uri"
require "cgi"

lib_path = File.expand_path('../bird-strike', __FILE__)
require "#{lib_path}/core.rb"
require "#{lib_path}/extend.rb"
require "#{lib_path}/window.rb"
require "#{lib_path}/timeline.rb"
require "#{lib_path}/authorization.rb"
require "#{lib_path}/file-io.rb"
#require "#{lib_path}/twitter-module.rb"
#require "#{lib_path}/input.rb"
