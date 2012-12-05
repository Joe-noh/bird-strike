#-*- coding: utf-8 -*-

module BirdStrike

  def self.launch
    Window.init
    Window.puts_title
    sleep 1

    @@conf = FileIO.get_config
    @@keys = FileIO.get_consumer_key_secret
    token  = FileIO.get_access_token

    if token.nil?
      Window.bottom(Twitter::Auth.get_oauth_url @@keys)
      begin
        pin = Window.prompt("pin").strip.to_i
        token = Twitter::Auth.get_oauth_token pin
        FileIO.store_access_token(token)
      rescue => e
        Window.bottom(e.message)
        retry
      end
    end
    @@keys.merge! token

    Twitter::Auth.authorize @@keys
    [Twitter::Streaming.thread, Input.thread].each(&:join)
  end

end

at_exit {
  BirdStrike::Window.at_exit
}
