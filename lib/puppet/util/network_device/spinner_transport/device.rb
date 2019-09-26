require 'puppet/resource_api/transport/wrapper'

# Initialize the NetworkDevice module if necessary
module Puppet::Util::NetworkDevice::SpinnerTransport; end

# The Spinner_transport module only contains the Device class to bridge from puppet's internals to the Transport.
# All the heavy lifting is done by the Puppet::ResourceApi::Transport::Wrapper
module Puppet::Util::NetworkDevice::Spinner_transport # rubocop:disable Style/ClassAndModuleCamelCase
  # Bridging from puppet to the spinner_transport transport
  class Device < Puppet::ResourceApi::Transport::Wrapper
    def initialize(url_or_config, _options = {})
      super('spinner_transport', url_or_config)
    end
  end
end
