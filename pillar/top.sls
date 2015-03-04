base:
  'controller':
    - openstack.rabbitmq
    - openstack.keystone
    - openstack.glance
    - openstack.nova
    - openstack.neutron
  'compute*':
    - openstack.rabbitmq
    - openstack.keystone
    - openstack.glance
    - openstack.nova
    - openstack.neutron
  'network':
    - openstack.rabbitmq
    - openstack.keystone
    - openstack.glance
    - openstack.nova
    - openstack.neutron
