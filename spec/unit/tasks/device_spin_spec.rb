require 'puppet'
require 'bolt_spec/run'
require_relative '../../fixtures/modules/ruby_task_helper/files/task_helper.rb'

# An example of testing a task using the helper

def puppet_6_or_greater?
  if Puppet.version.to_f >= 6.0 # Puppet 6 required for Bolt task execution
    return true
  end
  false
end

RSpec.configure do |config|
  # Do not run these specs on less than puppet 6
  config.filter_run_excluding bypass_on_less_than_puppet_6: true unless puppet_6_or_greater?
end

describe 'DeviceSpin task', :bypass_on_less_than_puppet_6 do
  let(:modulepath) { File.join(__dir__, '../../fixtures/modules') }

  let(:bolt_config) do
    { 'modulepath' => modulepath }
  end

  include BoltSpec::Run
  it 'runs device spin successfully with correct inputs' do
    result = run_task('test_device::device_spin', 'spinny', {},
                      inventory: { 'nodes' => [{
                        'name' => 'spinny.puppetlabs.net',
                        'alias' => 'spinny',
                        'config' => {
                          'transport' => 'remote',
                          'remote' => {
                            'cpu_time' => '2',
                            'wait_time' => '3',
                          },
                        },
                      }] })
    expect(result[0]['status']).to eq('success')
    expect(result[0]['result']['results']).to eq('spinner device spun: cpu_time 2, wait_time 3')
  end

  it 'returns error without cpu_time' do
    result = run_task('test_device::device_spin', 'spinny', {},
                      inventory: { 'nodes' => [{
                        'name' => 'spinny.puppetlabs.net',
                        'alias' => 'spinny',
                        'config' => {
                          'transport' => 'remote',
                          'remote' => {
                            'wait_time' => '3',
                          },
                        },
                      }] })
    expect(result[0]['status']).to eq('failure')
    expect(result[0]['result']['_error']['msg']).to eq("Parameter 'cpu_time' not found or contains illegal characters")
  end

  it 'returns error with invalid cpu_time' do
    result = run_task('test_device::device_spin', 'spinny', {},
                      inventory: { 'nodes' => [{
                        'name' => 'spinny.puppetlabs.net',
                        'alias' => 'spinny',
                        'config' => {
                          'transport' => 'remote',
                          'remote' => {
                            'cpu_time' => 'two',
                            'wait_time' => '3',
                          },
                        },
                      }] })
    expect(result[0]['status']).to eq('failure')
    expect(result[0]['result']['_error']['msg']).to eq("Parameter 'cpu_time' not found or contains illegal characters")
  end

  it 'returns error without wait_time' do
    result = run_task('test_device::device_spin', 'spinny', {},
                      inventory: { 'nodes' => [{
                        'name' => 'spinny.puppetlabs.net',
                        'alias' => 'spinny',
                        'config' => {
                          'transport' => 'remote',
                          'remote' => {
                            'cpu_time' => '2',
                          },
                        },
                      }] })
    expect(result[0]['status']).to eq('failure')
    expect(result[0]['result']['_error']['msg']).to eq("Parameter 'wait_time' not found or contains illegal characters")
  end

  it 'returns error with invalid wait_time' do
    result = run_task('test_device::device_spin', 'spinny', {},
                      inventory: { 'nodes' => [{
                        'name' => 'spinny.puppetlabs.net',
                        'alias' => 'spinny',
                        'config' => {
                          'transport' => 'remote',
                          'remote' => {
                            'cpu_time' => '2',
                            'wait_time' => 'three',
                          },
                        },
                      }] })
    expect(result[0]['status']).to eq('failure')
    expect(result[0]['result']['_error']['msg']).to eq("Parameter 'wait_time' not found or contains illegal characters")
  end
end
