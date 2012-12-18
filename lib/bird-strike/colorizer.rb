#-*- coding: utf-8 -*-

module BirdStrike
  class Colorizer
    attr_reader :color_of

    def initialize
      @color = Hash.new(0)
      build_dic
    end

    def color_of(name)
      @color[name =~ /^@\w+$/ ? name[1..-1] : name]
    end

    private
    def build_dic
      Twitter.lists.each_with_index do |list, i|
        break if i == 6
        Twitter.list_members(list).each do |user|
          @color[user.screen_name] = i+1
        end
      end
    end
  end
end
