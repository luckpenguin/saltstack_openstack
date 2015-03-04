base:
  controller:
    - openstack.salt_minion
    - openstack.dep
    - openstack.ntp
    - openstack.mariadb
    - openstack.rabbitmq
    - openstack.juno_pkg
    - openstack.keystone
    - openstack.glance
    - openstack.nova_server
    - openstack.neutron_server
    - openstack.horizon

  compute*:
    - openstack.salt_minion
    - openstack.dep
    - openstack.ntp
    - openstack.juno_pkg
    - openstack.nova_compute
    - openstack.neutron_compute

  network:
    - openstack.salt_minion
    - openstack.dep
    - openstack.ntp
    - openstack.juno_pkg
    - openstack.neutron_network
