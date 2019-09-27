require 'puppet/resource_api'

Puppet::ResourceApi.register_transport(
  name: 'spinner_transport',
  desc: <<-EOS,
      This transport provides Puppet with the capability to connect to spinner_transport targets.
can be used to emulate interaction with a remote device.
    EOS
  features: [],
  connection_info: {
    get_cpu_time: {
      type: 'Numeric',
      desc: 'get_cpu_time',
    },
    get_wait_time: {
      type: 'Numeric',
      desc: 'get_wait_time',
    },
    facts_cpu_time: {
      type: 'Numeric',
      desc: 'facts_cpu_time',

    },
    facts_wait_time: {
      type: 'Numeric',
      desc: 'facts_wait_time',
    },
  },
)
