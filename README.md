# Basic Management Scripts for Vagrant

Scripts for running basic `vagrant` commands on Windows, Mac OS X, and Linux.

## What These Scripts Do

Provide a simple menu for the user to run any of the following `vagrant` commands within a particular Vagrant environment:

1. `destroy`

1. `halt`

1. `reload`

1. `suspend`

1. `up`

1. `version` (requires Vagrant 1.6.0+)

The Windows script also provides logic to optionally ensure that the script is being run as administrator. Doing this prevents the following problem (and perhaps others), which occurs when `vagrant up` is not run as administrator:

    vagrant@precise32:~$ # Create a symlink somewhere not shared between host/guest
    vagrant@precise32:~$ ln -s /etc/hosts /home/vagrant/
    vagrant@precise32:~$ # Create a symlink somewhere shared between host/guest
    vagrant@precise32:~$ ln -s /etc/hosts /vagrant/
    ln: failed to create symbolic link `/vagrant/hosts': Protocol error

## Purpose

I wrote these scripts for co-workers who prefer to not run `vagrant` commands manually.

## Requirements

1. [Vagrant](http://www.vagrantup.com/) 1.4.0+ (1.6.0+ is recommended so that `vagrant version` works)

1. A Vagrant environment

## Usage

Place the appropriate script in the same directory as your "Vagrantfile" file. If you're on Windows, open the script in a text editor and make sure the `VAGRANT_MACHINE_REQUIRES_ADMIN` environment variable is set to the value you would like it to be set to (`True` or `False`). After that, simply run the script.
