#-*- coding: utf-8 -*-

module BirdStrike
  module Input
    MODE = [:tweet, :cmd]

    def self.thread
      Thread.new do
        begin
          MODE.cycle do |mode|
            input = Window.prompt mode.to_s
            next if input.strip.size == 0

            if mode == :tweet
              Window.prompt input
            else
              process_cmd(input)
            end
          end
        rescue
          Window.goodbye
          exit 1
        end
      end
    end

  end
end
