#!/opt/puppetlabs/puppet/bin/ruby

require 'puppet'
require 'puppet/resource_api/transport'

require_relative '../../ruby_task_helper/files/task_helper.rb'

# Return an error
def return_error(exception)
  result = {}
  result[:_error] = {
    msg:     exception.message,
    kind:    'puppetlabs/spinner',
    details: exception.backtrace,
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
    # puts params.inspect
    Dir.glob(File.join([params[:_installdir], '*'])).each do |mod|
      $LOAD_PATH << File.join([mod, 'lib'])
    end

    connection = if params[:_target][:"remote-transport"] == 'spinner_transport'
                   Puppet::ResourceApi::Transport.connect('spinner_transport', params[:_target])
                 else
                   require 'puppet/util/network_device/spinner/device'
                   Puppet::Util::NetworkDevice::Spinner::Device.new(params)
                 end
    connection.spin(params[:cpu_time], params[:wait_time])
    return_success("spinner device spun: cpu_time #{params[:cpu_time]}, wait_time #{params[:wait_time]}")
  rescue StandardError => e
    return_error(e)
  end
end

if $PROGRAM_NAME == __FILE__
  DeviceSpin.run
end
