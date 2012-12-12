#-*- coding: utf-8 -*-

module BirdStrike

  class Core

    def initialize
      Curses.init

      home_win = Curses::Window.new(0, 0, 0, 0)
      home_tl = Timeline.new(home_win)
      home_win.puts_title
      sleep 1

      @@conf = FileIO.get_config
      keys   = FileIO.get_consumer_key_secret
      token  = FileIO.get_access_token

      if token.nil?
        home_tl.print_center(Authorization.get_oauth_url keys, -4)
        begin
          pin   = home_tl.prompt("pin").strip.to_i
          token = Authorization.get_oauth_token(pin)
        rescue => e
          home_tl.print_center(e.message, -2)
          retry
        end
        FileIO.store_access_token token
      end
      Authorization.authorize(keys.merge token)
      @@stream_client = TweetStream::Client.new

      home_tl.stream = Thread.new {
        @@stream_client.userstream(&home_tl.on_receipt)
      }
      home_tl.stream.join

      Thread.new{
        loop do
          sleep 1
        end
      }.join
      #[TwitterModule::Streaming.thread, InputLoop.thread].each(&:run)
    end

    def new_stream(method, *args)
      tl.stream = Thread.new {
        @@stream_client.send(method, *args, &tl.on_receipt)
      }
      return tl
    end

  end
end

at_exit {
  Curses.close_screen
}
