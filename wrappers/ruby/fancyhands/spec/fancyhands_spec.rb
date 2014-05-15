require 'fancyhands'

describe Fancyhands do
  it 'delegates key and secret to config' do
    Fancyhands.key.should == 'example_key'
    Fancyhands.secret.should == 'example_secret'
  end
end
