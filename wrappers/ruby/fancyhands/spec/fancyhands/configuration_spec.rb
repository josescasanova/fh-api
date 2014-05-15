require 'spec_helper'
require 'fancyhands/configuration'

module Fancyhands
  describe Configuration do
    it 'sets a key' do
      config = Configuration.new
      config.set_key('blah')
      config.key.should == 'blah'
    end

    it 'sets a secret' do
      config = Configuration.new
      config.set_secret('blah')
      config.secret.should == 'blah'
    end

    describe '#initialize' do
      it 'reads from config/fancyhands.yml' do
        config = Configuration.from_config

        config.key.should == 'example_key'
        config.secret.should == 'example_secret'
      end
    end
  end
end
