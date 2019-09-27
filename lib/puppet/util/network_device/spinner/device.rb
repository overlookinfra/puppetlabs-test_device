require 'puppet/util/network_device/simple/device'
require_relative '../../../spinner.rb'

module Puppet::Util::NetworkDevice::Spinner
  # This device can be used to emulate interaction with a remote device.
  # Set the `facts_cpu_time` and `facts_wait_time` config options to add a one-time cpu and wall clock delay to the spinner facts gathering
  class Device < Puppet::Util::NetworkDevice::Simple::Device
    include Spinner
    def initialize(_context, config)
      @config = config
    end
  end
end
