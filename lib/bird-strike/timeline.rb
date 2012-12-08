module BirdStrike
  class Timeline
    # TwitterOAuth before this
#    @@client = TweetStream::Client.new

    def initialize(tw_method, *arg)
      @stream = @@client.send(tw_method, arg)
    end
  end
end

def g(a)
  puts a
end

def func(a, *b)
  puts a
  g b
end

func(1)
