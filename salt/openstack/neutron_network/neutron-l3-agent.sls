/etc/neutron/l3_agent.ini:
  file.managed:
    - source: salt://openstack/neutron_server/l3_agent.ini
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_network

neutron-l3-agent
neutron-server:
  service.running:
    - watch:
      - file: /etc/neutron/neutron.conf 
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
