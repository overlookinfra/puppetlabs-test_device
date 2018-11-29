require 'puppet/util/network_device/simple/device'

module Puppet::Util::NetworkDevice::Spinner
  # This device can be used to emulate interaction with a remote device.
  # Set the `facts_cpu_time` and `facts_wait_time` config options to add a one-time cpu and wall clock delay to the spinner facts gathering
  class Device < Puppet::Util::NetworkDevice::Simple::Device
    def spin(cpu_time, wait_time)
      Puppet.info("Spinning for #{cpu_time}s and waiting for #{wait_time}s")
      starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      while (Process.clock_gettime(Process::CLOCK_MONOTONIC) - starting) < cpu_time
      str = 'f'
        1000.times do
          str << 'u'
        end
      end
      sleep wait_time
    end

    def facts
      spin(facts_cpu_time, facts_wait_time)
      {}
    end

    def get_cpu_time
      (config['get_cpu_time'] || 0).to_f
    end
    def get_wait_time
      (config['get_wait_time'] || 0).to_f
    end
    def facts_cpu_time
      (config['facts_cpu_time'] || 0).to_f
    end
    def facts_wait_time
      (config['facts_wait_time'] || 0).to_f
    end
  end
end
