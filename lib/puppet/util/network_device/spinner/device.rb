require 'puppet/util/network_device/simple/device'
require_relative '../spinner_common'

module Puppet::Util::NetworkDevice::Spinner
  # This device can be used to emulate interaction with a remote device.
  # Set the `facts_cpu_time` and `facts_wait_time` config options to add a one-time cpu and wall clock delay to the spinner facts gathering
  class Device < Puppet::Util::NetworkDevice::Simple::Device
    include SpinnerCommon
    def initialize(config)
      @config = config
      puts 'spinner device'
    end
  end
end
