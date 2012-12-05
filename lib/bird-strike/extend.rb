#-*- coding: utf-8 -*-

class String
  def width
    self.each_char.inject(0) do |sum, c|
      (c.ascii_only? ? 1 : 2 ) + sum
    end
  end
end

module Twitter
  class Tweet
    def name_text_rtby
      if self.retweet?
        status = self.retweeted_status
        rt_by = "[Retweeted by #{self.from_user}]"
      else
        status = self
      end
      name = ' '+status.from_user+': '
      return name, CGI.unescapeHTML(status.text), rt_by
    end
  end
end
