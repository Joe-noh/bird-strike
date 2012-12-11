#-*- coding: utf-8 -*-

module BirdStrike
  class Stream
    attr_reader :client

    @@client = TweetStream::Client.new
    @@tracking_threads = Hash.new

    def initialize(method, *args)
    end


    def self.thread
      @@stream = TweetStream::Client.new

      @@stream.on_timeline_status do |status|
        Window.add_tweet_status(status)
      end

      @@stream.on_error do |message|; end

      @@stream.on_reconnect do |timeout, retries|; end

      Thread.new{ @@stream.userstream }
    end

    def add_track_word(word)
      return if @@tracking_threads.has_key? word
      @@tracking_threads[word] = Thread.new{ @@stream.track word }
      @@tracking_threads[word].join
    end

    def del_track_word(word)
      return unless @@tracking_threads.has_key? word
      @@tracking_threads[word].kill
    end
  end
end
