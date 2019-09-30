require 'spec_helper'
require 'puppet/transport/schema/spinner_transport'

RSpec.describe 'the spinner_transport transport' do
  it 'loads' do
    expect(Puppet::ResourceApi::Transport.list['spinner_transport']).not_to be_nil
  end
end
