#-*- coding: utf-8 -*-

module BirdStrike

  def self.launch
    @@win = Window.new
    @@win.puts_title
    sleep 1

    @@conf = FileIO.get_config
    keys   = FileIO.get_consumer_key_secret
    token  = FileIO.get_access_token

    if token.nil?
      @@win.print_center(TwitterModule::Auth.get_oauth_url keys, -4)
      begin
        pin = @@win.prompt("pin").strip.to_i
        token = Authorization.get_oauth_token pin
        FileIO.store_access_token token
      rescue => e
        @@win.print_center(e.message, -2)
        retry
      end
    end
    TwitterModule::Auth.authorize(keys.merge token)

    [TwitterModule::Streaming.thread, InputLoop.thread].each(&:join)
  end

end

at_exit {
  BirdStrike::Window.at_exit
}
