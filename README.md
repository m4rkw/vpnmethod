VPN Method
==========

This is an example of a VPN server configuration for Debian and
Debian-compatible distributions.

The configuration is applied using ansible and installs the following
components:

1. OpenVPN client connecting to the ipredator.se VPN service (but can be
changed to the VPN provider of your choice).

2. Privoxy and Tor system services.

3. L2TP over IPSEC configuration to allow mac and iOS clients to connect to the
server.

This will build a VPN server that connects to the ipredator service and also
acts as a VPN server itself. The client accounts for the server can be operated
in three modes:

1. Traffic is routed straight out of the server over its default interface.

2. Traffic is routed over the OpenVPN tunnel (eg via ipredator.se).

3. Traffic is routed over tor.

Using this configuration you can buy one VPN and then use it on multiple devices
by essentially relaying the connection through the server. As an example we will
create 3 accounts for iOS and 3 for mac that operate in each of these three
modes.


Notes
-----

This was tested with Ubuntu 16.04 and 17.04. It should more or less work with
any Debian-style distro but you may need to tweak some config.


Setup
-----

1. First you need a server. I highly recommend linode but you can also test this
locally with a virtual machine.

2. Set up a user account on the server that has passwordless sudo access and
passwordless ssh key authentication.

3. Initialise the ansible inventory with with the hostname or IP and your user
account:

````
$ ./setup.sh 172.16.13.132 ansible
````

4. Put your ipredator.ta.key keyfile in the keys/ directory

5. Copy the example secrets.yml file to vars/secrets.yml

````
$ cp vars/secrets.yml.example vars/secrets.yml
````

6. Add your ipredator username/password to vars/secrets.yml and adjust the DNS
servers you want VPN clients to use. The servers currently listed are for the
ipredator.se service. Using the correct DNS servers is important to avoid
leakage.

7. Generate random keys for the ipsec PSK (pre-shared key) and the keys for the
individual VPN accounts:

````
$ ./generate_keys.rb
````

8. Make sure you have ansible installed:

````
$ sudo pip install ansible
````

9. Run the ansible playbook to configure the server

````
$ ansible-playbook -i inventory playbooks/server.yml
````


Client configuration
--------------------

Now you can configure the VPNs on your Mac/iOS devices. You need the "L2TP over
IPSec" type, ensure to set the username, password and PSK according to your
secrets.yml file. Also make sure you select "Send all traffic over the VPN".

To use the tor routing you need to additionally configure a proxy setting for
the tor vpn profile:

type: HTTP
host: 10.2.2.1
port: 8118

This will route the traffic for that VPN profile via Privoxy and over the tor
network.
