require 'spec_helper'

describe 'Google Oauth' do
  it 'gets a code' do
    oauther = Oauthorizer::Token.new
    @token_hash = oauther.get_google_token_hash
    puts @token_hash
    @token_hash['access_token'].should == '26827780047.apps.googleusercontent.com'
  end

end