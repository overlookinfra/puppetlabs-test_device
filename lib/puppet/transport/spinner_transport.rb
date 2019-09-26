module Puppet::Transport
  # The main connection class to a SpinnerTransport endpoint
  class SpinnerTransport
    # Initialise this transport with a set of credentials
    def initialize(_context, connection_info)
      @config = connection_info
    end

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

    # Set the `facts_cpu_time` and `facts_wait_time` config options to add a one-time cpu and wall clock delay to the spinner facts gathering
    def facts
      spin(facts_cpu_time, facts_wait_time)
      {}
    end

    # rubocop:disable Style/AccessorMethodName
    def get_cpu_time
      (@config[:cpu_time] || 0).to_f
    end

    def get_wait_time
      (@config[:wait_time] || 0).to_f
    end

    # rubocop:enable Style/AccessorMethodName
    def facts_cpu_time
      (@config[:facts_cpu_time] || 0).to_f
    end

    def facts_wait_time
      (@config[:facts_wait_time] || 0).to_f
    end

    # Verifies that the stored credentials are valid, and that we can talk to the target
    def verify(_context); end

    # Close the connection and release all resources
    def close(_context); end
  end
end
