require 'puppet'
require_relative '../../fixtures/modules/ruby_task_helper/files/task_helper.rb'
require_relative '../../../lib/puppet/util/network_device/spinner/device'
require_relative '../../../tasks/device_spin'

# An example of testing a task using the helper

describe 'DeviceSpin task' do
  it 'runs device spin successfully with correct inputs' do
    allow(STDIN).to receive(:read)
      .and_return('{"_task":"test_device::device_spin", "_target":{"run-on":"localhost", "cpu_time":2, "wait_time":3,'\
                  '"name":"spinny.puppetlabs.net", "uri":"spinny.puppetlabs.net", "protocol":"remote", "host":"spinny.puppetlabs.net"}}')
    expect(STDOUT).to receive(:puts).with('{"status":"success","results":"spinner device spun: cpu_time 2, wait_time 3"}')
    DeviceSpin.run
  end

  it 'returns error without cpu_time' do
    allow(STDIN).to receive(:read)
      .and_return('{"_task":"test_device::device_spin", "_target":{"run-on":"localhost", "wait_time":3,'\
                  ' "name":"spinny.puppetlabs.net", "uri":"spinny.puppetlabs.net", "protocol":"remote", "host":"spinny.puppetlabs.net"}}')
    expect(STDOUT).to receive(:puts).with("{\"_error\":{\"msg\":\"Parameter 'cpu_time' not found or contains illegal characters\",\"kind\":\"puppetlabs/spinner\",\"details\":{}}}")
    DeviceSpin.run
  end

  it 'returns error with invalid cpu_time' do
    allow(STDIN).to receive(:read)
      .and_return('{"_task":"test_device::device_spin", "_target":{"run-on":"localhost", "cpu_time":"two", "wait_time":3,'\
                  ' "name":"spinny.puppetlabs.net", "uri":"spinny.puppetlabs.net", "protocol":"remote", "host":"spinny.puppetlabs.net"}}')
    expect(STDOUT).to receive(:puts).with("{\"_error\":{\"msg\":\"Parameter 'cpu_time' not found or contains illegal characters\",\"kind\":\"puppetlabs/spinner\",\"details\":{}}}")
    DeviceSpin.run
  end

  it 'returns error without wait_time' do
    allow(STDIN).to receive(:read)
      .and_return('{"_task":"test_device::device_spin", "_target":{"run-on":"localhost",'\
                  ' "cpu_time":2, "name":"spinny.puppetlabs.net", "uri":"spinny.puppetlabs.net", "protocol":"remote", "host":"spinny.puppetlabs.net"}}')
    expect(STDOUT).to receive(:puts).with("{\"_error\":{\"msg\":\"Parameter 'wait_time' not found or contains illegal characters\",\"kind\":\"puppetlabs/spinner\",\"details\":{}}}")
    DeviceSpin.run
  end

  it 'returns error with invalid wait_time' do
    allow(STDIN).to receive(:read)
      .and_return('{"_task":"test_device::device_spin", "_target":{"run-on":"localhost", "cpu_time":2, "wait_time":"three",'\
                  ' "name":"spinny.puppetlabs.net", "uri":"spinny.puppetlabs.net", "protocol":"remote", "host":"spinny.puppetlabs.net"}}')
    expect(STDOUT).to receive(:puts).with("{\"_error\":{\"msg\":\"Parameter 'wait_time' not found or contains illegal characters\",\"kind\":\"puppetlabs/spinner\",\"details\":{}}}")
    DeviceSpin.run
  end
end
