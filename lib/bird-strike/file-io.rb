#-*- coding: utf-8 -*-

module BirdStrike
  module FileIO

    def self.get_config
      @@read_yaml["../../../conf/conf.yaml"]
    end

    def self.get_consumer_key_secret
      @@read_yaml["../../../key/consumer.yaml"]
    end

    def self.get_access_token
      path = File.join(Dir.home, ".bird-strike.d/token.yaml")
      @@read_yaml[path] rescue nil
    end

    def self.store_access_token(token)
      dir = File.join(Dir.home, ".bird-strike.d")
      Dir.mkdir(dir, 0600) unless File.exists? dir
      File.open(File.join(dir, "token.yaml"), 'w') do |f|
        YAML.dump(token, f)
      end
    end

    # private
    @@read_yaml = lambda do |file|
      yaml = YAML.load_file File.expand_path(file, __FILE__)
      Hash[*yaml.keys.map(&:to_sym).zip(yaml.values.map(&:strip)).flatten]
    end
  end
end
