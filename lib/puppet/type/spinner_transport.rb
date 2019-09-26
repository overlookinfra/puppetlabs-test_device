require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'spinner_transport',
  docs: <<-EOS,
    This type can be used to emulate interaction with a remote device.

    When the `trigger` property is set to `true`, a change event is generated for the resource, and the `cpu_time` and `wait_time` parameters determine the amount of cpu and wall clock time spent in a request. When the `trigger` property is set to `false`, no additional effort is spent. This can be used to tune the workload to different requirements.

    Set the `get_cpu_time` and `get_wait_time` config options to add a one-time cpu and wall clock delay to the spinner type overall.
  EOS
  features: [], # 'remote_resource' ],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type:      'String',
      desc:      'The name of the resource you want to manage.',
      behaviour: :namevar,
    },
    trigger: {
      type: 'Boolean',
      desc: 'Whether or not to trigger a change event for this resource.',
    },
    cpu_time: {
      type: 'Numeric',
      desc: 'How many seconds of CPU time to burn per resource.',
      behaviour: :parameter,
      default: 0,
    },
    wait_time: {
      type: 'Numeric',
      desc: 'How many seconds of CPU time to sleep per resource.',
      behaviour: :parameter,
      default: 0,
    },
  },
)
