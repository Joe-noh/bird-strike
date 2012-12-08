#-*- coding: utf-8 -*-

module BirdStrike
  module InputLoop

    def self.thread
      Thread.new do
        begin
          loop do
            input = Window.prompt
            next if input.strip.size == 0

            Twitter.update input
          end
        rescue
          Window.goodbye
          exit 1
        end
      end
    end

  end
end
