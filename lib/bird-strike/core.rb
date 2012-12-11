#-*- coding: utf-8 -*-

module BirdStrike

  class Core

    def initialize
      @tweets_array = Array.new
    end

    def launch
      @win = Window.new
      @win.puts_title
      sleep 1

      @@conf = FileIO.get_config
      keys   = FileIO.get_consumer_key_secret
      token  = FileIO.get_access_token

      if token.nil?
        @win.print_center(Authorization.get_oauth_url keys, -4)
        begin
          pin   = @win.prompt("pin").strip.to_i
          token = Authorization.get_oauth_token(pin)
        rescue => e
          @win.print_center(e.message, -2)
          retry
        end
        FileIO.store_access_token token
      end
      Authorization.authorize(keys.merge token)
      @@stream_client = TweetStream::Client.new

      home = new_stream(:userstream)
      puts home.stream.join

      Thread.new{
        loop do
          sleep 1
        end
      }.join
      #[TwitterModule::Streaming.thread, InputLoop.thread].each(&:run)
    end

    def new_stream(method, *args)
      tl = Timeline.new(@win)
      tl.stream = Thread.new {
        @@stream_client.send(method, *args, &tl.on_receipt)
      }
      return tl
    end

  end
end

at_exit {
  BirdStrike::Window.at_exit
}
