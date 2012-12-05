#-*- coding: utf-8 -*-

module BirdStrike
  module Twitter
    module Streaming
      @@tracking_threads = Hash.new

      def self.thread
        @@stream = TweetStream::Client.new

        @@stream.on_timeline_status do |status|
          Window.add_tweet_status(status)
        end

        @@stream.on_error do |message|
          print "Error: #{message}\n"
        end

        @@stream.on_reconnect do |timeout, retries|
          print "Reconnecting in: #{timeout} seconds\n"
        end

        @@userstream = Thread.new{ @@stream.userstream }
        @@userstream
      end

      def self.add_track_word(word)
        return if @@tracking_threads.has_key? word
        @@tracking_threads[word] = Thread.new{ @@stream.track word }
        @@tracking_threads[word].join
      end

      def self.del_track_word(word)
        return unless @@tracking_threads.has_key? word
        @@tracking_threads[word].kill
      end
    end

    module Auth
      def self.get_oauth_url(keys)
        @@oauth = OAuth::Consumer.new(keys[:consumer_key],
                                      keys[:consumer_secret],
                                      :site => "https://twitter.com")
        @@req_token = @@oauth.get_request_token
        @@req_token.authorize_url
      end

      def self.get_oauth_token(pin)
        token = @@req_token.get_access_token(:oauth_verifier => pin)
        FileIO.store_access_token token
        {:token => token.token, :token_secret => token.secret}
      end

      def self.authorize(keys)
        TweetStream.configure do |conf|
          conf.consumer_key       = keys[:consumer_key]
          conf.consumer_secret    = keys[:consumer_secret]
          conf.oauth_token        = keys[:token]
          conf.oauth_token_secret = keys[:token_secret]
          conf.auth_method = :oauth
        end
      end
    end
  end
end
