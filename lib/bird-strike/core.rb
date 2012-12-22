#-*- coding: utf-8 -*-

module BirdStrike
  class Core

    def initialize
      Curses.init

      @title_window = TitleWindow.new
      @title_window.puts_title
      sleep 1

      @conf = FileIO.get_config
      @prompt = Prompt.new
      authorize

      @timelines = [Timeline.new(0, 0, 0, 0)] # Home Timeline
      @timelines.first.window.keypad(true)
    end

    def main_loop
      loop do
        @timelines.each(&:renew)
        cmd = @timelines.first.window.getch
        Timeline.stop_updating
        case cmd                     # Input Processing
        when 13, Curses::Key::ENTER  # Enter
          tweet = @prompt.get_input
          Twitter.update(tweet) unless tweet.nil?
        when 't'                     # T
          track = @prompt.get_line("track word:")
          next if track.nil?
          @timelines << Timeline.new(0, 0, 0, 0, :track, track)
          maxy, maxx = Curses.stdscr.maxyx
          n = @timelines.size
          @timelines.each_with_index do |tl, i|
            tl.window.resize(maxy, maxx/n)
            tl.window.move(0, i*maxx/n)
          end
        when Curses::Key::UP
          @timelines.each(&:scroll_up)
        when Curses::Key::DOWN
          @timelines.each(&:scroll_down)
        end
        Timeline.start_updating
      end
    end

    def authorize
      keys   = FileIO.get_consumer_key_secret
      token  = FileIO.get_access_token

      if token.nil?  # not authorized
        @title_window.print_in_middle(Authorize.get_oauth_url(keys), -4)
        begin
          pin   = @prompt.get_line("pin:").strip.to_i
          token = Authorize.get_oauth_token(pin)
        rescue => e
          @title_window.print_in_middle(e.message, -4)
          retry
        end
        FileIO.store_access_token token
      end
      Authorize.authorize(keys.merge token)
    end

  end
end

at_exit {
  Curses.close_screen
}
