require 'spec_helper'

ensure_module_defined('Puppet::Provider::Spinner')
require 'puppet/provider/spinner/spinner'

RSpec.describe Puppet::Provider::Spinner::Spinner do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:device) { instance_double('Puppet::Util::NetworkDevice::Spinner::Device', 'device') }

  describe '#get' do
    it 'processes resources' do
      expect(context).to receive(:device).and_return(device).exactly(3).times
      expect(device).to receive(:get_cpu_time).and_return(40)
      expect(device).to receive(:get_wait_time).and_return(41)
      expect(device).to receive(:spin).with(40, 41)
      expected_result = []
      (0..999).map do |i|
        expected_result.push(
          name: i.to_s,
          ensure: 'present',
          trigger: false,
        )
      end
      expect(provider.get(context)).to eq(expected_result)
    end
  end

  describe 'create(context, name, should)' do
    it 'creates the resource' do
      expect(context).to receive(:device).and_return(device)
      expect(device).to receive(:spin).with(42, 43)
      provider.create(context, 'a', name: 'a', cpu_time: 42, wait_time: 43, ensure: 'present')
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the resource' do
      expect(context).to receive(:device).and_return(device)
      expect(device).to receive(:spin).with(42, 43)
      provider.update(context, 'foo', name: 'foo', cpu_time: 42, wait_time: 43, ensure: 'present')
    end
  end

  describe 'delete(context, name)' do
    it 'deletes the resource' do
      expect(Puppet).to receive(:info).with('not spinning on delete of foo')
      provider.delete(context, 'foo')
    end
  end
end
