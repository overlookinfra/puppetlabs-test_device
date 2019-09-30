require 'spec_helper'

require 'puppet/transport/spinner_transport'

RSpec.describe Puppet::Transport::SpinnerTransport do
  subject(:transport) { described_class.new(context, connection_info) }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  # let(:connection_info) do
  #   {
  #     host: 'api.example.com',
  #     user: 'admin',
  #     password: 'aih6cu6ohvohpahN',
  #   }
  # end
  #
  let(:connection_info) do
    {
      facts_cpu_time: 0.1,
      facts_wait_time: 0.2,
      get_cpu_time: 1.1,
      get_wait_time: 1.2,
    }
  end

  before(:each) do
    allow(context).to receive(:debug)
  end

  describe 'initialize(context, connection_info)' do
    it { expect { transport }.not_to raise_error }
  end

  describe 'verify(context)' do
    context 'with valid credentials' do
      it 'returns' do
        expect { transport.verify(context) }.not_to raise_error
      end
    end

    # context 'with invalid credentials' do
    #   let(:connection_info) { super().merge(password: 'invalid') }
    #
    #   it 'raises an error' do
    #     expect { transport.verify(context) }.to raise_error RuntimeError, %r{authentication error}
    #   end
    # end
  end

  describe 'facts(context)' do
    let(:facts) { transport.facts }

    it 'returns basic facts' do
      expect(facts).to include({})
    end
  end

  describe 'close(context)' do
    it 'releases resources' do
      transport.close(context)

      expect(transport.instance_variable_get(:@connection_info)).to be_nil
    end
  end
end
