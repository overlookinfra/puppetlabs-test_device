require 'spec_helper'
require 'puppet/type/spinner'

RSpec.describe 'the spinner type' do
  it 'loads' do
    expect(Puppet::Type.type(:spinner)).not_to be_nil
  end
end
