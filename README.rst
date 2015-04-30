===========
demo-app-2
===========

.. note::

    Please note that several states include other states which are NOT part of this repository. 
    I have left them available as examples that you can easily fill in, and some which you can omit.
    In addition this repository is a companion to
    `demo-app-1 <https://github.com/gravyboat/demo-app-1>`_.

Setup with Vagrant
===================

Download and install VirtualBox and Vagrant. If you have old versions of either, you may need to upgrade
to a newer version.

Installing Virtualbox
----------------------

Download the .dmg from here: https://www.virtualbox.org/wiki/Downloads

Follow the instructions here: https://www.virtualbox.org/manual/ch02.html#idp52694656

Installing Vagrant
-------------------
https://docs.vagrantup.com/v2/installation/index.html

Preparing the repo
-------------------

.. code-block::

    git clone https://github.com/gravyboat/demo-app-2.git
    cd demo-app-2

Bringing up the VM
-------------------

.. code-block::
    
    vagrant up

If this fails, you may need to visit the 
`config.vm.box_url <http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box>`_
specified in the *Vagrantfile* to download the image. Once downloaded, move the image to a directory
like *~/VM_boxes/*, and add the image to vagrant: 

.. code-block::

    vagrant box add <path-to-image> --name centos-min

Connecting to the system
-------------------------

.. code-block::
    
    vagrant ssh
    cd /home/vagrant/demo-app-2

At this point the Flask app should be up and running and available at http://192.168.44.2:8080.
If you have not brought up `demo-app-1 <https://github.com/gravyboat/demo-app-1>`_
then Nginx requests to http://192.168.44.3 will not redirect to the Flask app.

Available states
================

.. contents::
  :local:

``demo-app-2``
---------------

Installs and configures our Flask application, virtualenv, and the supervisord service
for the demo app as though it was on a production system, creating users and performing
a git checkout.

``demo-app-2.dev``
---------------------

Installs and configures our Flask application, virtualenv, and the supervisord service
for the demo app with Vagrant settings unless otherwise specified in the pillar.
