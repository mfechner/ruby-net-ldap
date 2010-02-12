require 'spec_helper'

require 'socket'
require 'openssl'

require 'net/ldap'

describe "BER serialisation (SSL)" do
  # Transmits str to #to and reads it back from #from. 
  #
  def transmit(str)
    to.write(str)
    to.close
    
    from.read
  end
  
  attr_reader :to, :from
  before(:each) do
    @from, @to = IO.pipe
    
    @to   = Net::LDAP::SSLSocket.wrap(to)
    @from = Net::LDAP::SSLSocket.wrap(from)
  end
  
  it "should transmit strings" do
    transmit('foo').should == 'foo'
  end 
  it "should correctly transmit numbers" do
    to.write 1234.to_ber
    from.read_ber.should == 1234
  end 
end