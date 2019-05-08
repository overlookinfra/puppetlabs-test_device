
# test_device

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with test_device](#setup)
    * [What test_device affects](#what-test_device-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with test_device](#beginning-with-test_device)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module contains a test device that only burns CPU and wall clock time to be used during performance testing. The two different knobs are intended to simulate connection and data processing overhead, as well as delays when waiting on a devices response.

## Setup

Configure an arbitrary amount of devices using the `spinner` type in your `device.conf`. Inthe credentials you can configure extra wait times for fetching facts and retrieving resources as `facts_cpu_time`, `facts_wait_time`, `get_cpu_time` and `get_wait_time`. All times can be specified in fractional seconds.

### Requirement for executing task

The [puppetlabs-ruby_task_helper](https://forge.puppet.com/puppetlabs/ruby_task_helper) module should be installed

## Usage

* Create a catalog with an appropriate number of `spinner` resources in it.
* Set the `cpu_time` and `wait_time` as appropriate for the devices you want to emulate.
* Run `puppet device` to execute those catalogs.
* ???
* Profit!

### Executing task

The `device_spin` task can be executed from bolt by supplying an basic inventory file:

* `name` Name of the device (no used by test_device)
* `alias` Alias to use for the device
* `config` of which:
  * `transport` Always `remote`

For example:

```
nodes:
  - name: spinny.example.net
    alias: spinny
    config:
      transport: remote
```

Bolt executes the task with the following command:

`bolt task run test_device::device_spin --nodes spinny --modulepath /etc/puppetlabs/code/environments/production/modules/ --inventoryfile ./inventory.yaml  --param '{"cpu_time": 2, "wait_time": 3}'`

Changing the param values of `cpu_time` and `wait_time` will affect the test_device as defined in [device_spin.json](tasks/device_spin.json)

## Limitations

Understanding the required cpu and wait times to emulate a realistic work load is left as an exercise to the reader, as this is dependent on the mix of devices you are running.

There are currently no known bugs.

## Development

PRs on github always appreciated!
