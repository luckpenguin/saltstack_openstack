net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0
net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0

br-em2:
  cmd.run:
    - name: ovs-vsctl add-br br-em2
    - unless: ovs-vsctl list-br | grep 'br-em2'

port-em2:
  cmd.run:
    - name: ovs-vsctl add-port br-em2 em2
    - unless: ovs-vsctl list-ports br-em2 | grep ^em2
    - require:
      - cmd: br-em2

neutron_network:
  pkg.installed:
    - pkgs:
      - neutron-plugin-ml2
      - neutron-plugin-openvswitch-agent
      - neutron-l3-agent
      - neutron-dhcp-agent
      - neutron-metadata-agent

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://openstack/neutron_network/neutron.conf
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_network

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://openstack/neutron_network/ml2_conf.ini.vlan
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_network

/etc/neutron/l3_agent.ini:
  file.managed:
    - source: salt://openstack/neutron_network/l3_agent.ini
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_network

/etc/neutron/dhcp_agent.ini:
  file.managed:
    - source: salt://openstack/neutron_network/dhcp_agent.ini
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_network

/etc/neutron/metadata_agent.ini:
  file.managed:
    - source: salt://openstack/neutron_network/metadata_agent.ini
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_network

neutron-plugin-openvswitch-agent:
  service.running:
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - cmd: port-em2


neutron-l3-agent:
  service.running:
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/l3_agent.ini
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/l3_agent.ini

neutron-dhcp-agent:
  service.running:
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/dhcp_agent.ini
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/dhcp_agent.ini

neutron-metadata-agent:
  service.running:
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/metadata_agent.ini
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/metadata_agent.ini
