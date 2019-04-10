#!/opt/puppetlabs/puppet/bin/ruby

require 'puppet'
require 'puppet/util/network_device/config'

def require_module_file(file)
  return unless File.exist?("#{Puppet[:plugindest]}/#{file}.rb")
  require "#{Puppet[:plugindest]}/#{file}"
end

installdir_path = '../../ruby_task_helper/files/task_helper.rb'
local_path = '../files/task_helper.rb'

# Task is being run with bolt and helper is at location relative to task
if File.exist?(File.join(File.dirname(__FILE__), installdir_path))
  require_relative installdir_path
elsif File.exist?(File.join(File.dirname(__FILE__), local_path))
  require_relative local_path
end

# validate values.
def validate_parameters(cpu_time, wait_time)
  raise("Parameter 'cpu_time' not found or contains illegal characters") unless safe_int?(cpu_time)
  raise("Parameter 'wait_time' not found or contains illegal characters") unless safe_int?(wait_time)
end

# Similar with ints
def safe_int?(param)
  if param.nil?
    return false
  end
  Integer(param)
rescue
  false
end

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
    require_module_file('puppet/util/network_device/spinner/device')
    validate_parameters(params[:_target][:cpu_time], params[:_target][:wait_time])
    spinner_device = Puppet::Util::NetworkDevice::Spinner::Device.new(params[:_target])
    spinner_device.spin(params[:_target][:cpu_time].to_i, params[:_target][:wait_time].to_i)
    return_success("spinner device spun: cpu_time #{params[:_target][:cpu_time].to_i}, wait_time #{params[:_target][:wait_time].to_i}")
  rescue StandardError => e
    config_save_error = e.message
    return_error(config_save_error)
  end
end

if $PROGRAM_NAME == __FILE__
  DeviceSpin.run
end
