require 'puppet/resource_api/simple_provider'
require 'puppet/util/network_device/spinner/device'

# Implementation for the spinner type using the Resource API.
class Puppet::Provider::Spinner::Spinner < Puppet::ResourceApi::SimpleProvider
  def get(context)
    context.device.spin(context.device.get_cpu_time, context.device.get_wait_time)
    (0..999).collect do |i|
      {
        name: i.to_s,
        ensure: 'present',
        trigger: false,
      }
    end
  end

  def create(context, name, should)
    context.device.spin(should[:cpu_time], should[:wait_time])
  end

  def update(context, name, should)
    context.device.spin(should[:cpu_time], should[:wait_time])
  end

  def delete(context, name)
    Puppet.info("not spinning on delete of #{name}")
  end
end
