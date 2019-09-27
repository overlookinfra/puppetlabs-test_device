#!/opt/puppetlabs/puppet/bin/ruby

require 'puppet'
require_relative '../../ruby_task_helper/files/task_helper.rb'
require_relative '../../test_device/lib/puppet/util/network_device/spinner/device.rb'
require_relative '../../test_device/lib/puppet/util/network_device/spinner_common.rb'

# Return an error
def return_error(message)
  result = {}
  result[:_error] = {
    msg:     message,
    kind:    'puppetlabs/spinner',
    details: {},
  }
  puts result.to_json
end

# Return a result
def return_success(message)
  result = {}
  result[:status]  = 'success'
  result[:results] = message
  puts result.to_json
end

# Class for the DeviceSpin task
# Requires target in inventory set with CPU time and Wait time parameters
class DeviceSpin < TaskHelper
  def task(params)
    unless Puppet.settings.global_defaults_initialized?
      Puppet.initialize_settings
    end
    spinner_device = Puppet::Util::NetworkDevice::Spinner::Device.new(params)
    spinner_device.spin(params[:cpu_time], params[:wait_time])
    return_success("spinner device spun: cpu_time #{params[:cpu_time]}, wait_time #{params[:wait_time]}")
  rescue StandardError => e
    config_save_error = e.message
    return_error(config_save_error)
  end
end

if $PROGRAM_NAME == __FILE__
  DeviceSpin.run
end
