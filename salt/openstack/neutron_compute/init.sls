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

neutron_pkgs:
  pkg.installed:
    - pkgs:
      - neutron-plugin-ml2
      - neutron-plugin-openvswitch-agent

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://openstack/neutron_compute/neutron.conf
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_pkgs

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://openstack/neutron_compute/ml2_conf.ini.vlan
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_pkgs

neutron-plugin-openvswitch-agent:
  service.running:
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - cmd: port-em2
