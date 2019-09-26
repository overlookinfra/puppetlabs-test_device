require 'puppet/resource_api/simple_provider'

# Implementation for the spinner type using the Resource API.
class Puppet::Provider::SpinnerTransport::SpinnerTransport < Puppet::ResourceApi::SimpleProvider
  def get(context)
    context.transport.spin(context.transport.get_cpu_time, context.transport.get_wait_time)
    (0..999).map do |i|
      {
          name: i.to_s,
          ensure: 'present',
          trigger: false,
      }
    end
  end

  def create(context, _name, should)
    context.transport.spin(should[:cpu_time], should[:wait_time])
  end

  def update(context, _name, should)
    context.transport.spin(should[:cpu_time], should[:wait_time])
  end

  def delete(_context, name)
    Puppet.info("not spinning on delete of #{name}")
  end
end
