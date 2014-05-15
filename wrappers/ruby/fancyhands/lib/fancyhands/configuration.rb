module Fancyhands
  class Configuration
    attr_reader :key, :secret

    def set_key(key)
      @key = key
    end

    def set_secret(secret)
      @secret = secret
    end

    def self.from_config
      config = Configuration.new
      config.set_key(config_file['key'])
      config.set_secret(config_file['secret'])
      config
    end

    def self.config_file
      YAML.load(file)
    end

    def self.file
      @file ||= File.read('./config/fancyhands.yml')
    end
  end
end
