require_relative '../spinner.rb'

module Puppet::Transport
  # The main connection class to a SpinnerTransport endpoint
  class SpinnerTransport
  include Spinner
  # Initialise this transport with a set of credentials
    def initialize(_context, connection_info)
      @config = connection_info
    end

    # Verifies that the stored credentials are valid, and that we can talk to the target
    def verify(_context); end

    # Close the connection and release all resources
    def close(_context); end
  end
end
