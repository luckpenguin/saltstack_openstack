neutron_server:
  pkg.installed:
    - pkgs:
      - neutron-server
      - neutron-plugin-ml2
      - python-neutronclient

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://openstack/neutron_server/neutron.conf
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_server

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://openstack/neutron_server/ml2_conf.ini.vlan
    - user: neutron
    - group: neutron
    - mode: 640
    - template: jinja
    - require:
      - pkg: neutron_server

neutron-server:
  service.running:
    - watch:
      - file: /etc/neutron/neutron.conf 
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini

neutron_db_sync:
  cmd.run:
    - name: neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno 
    - cwd: /tmp/
    - user: neutron
    - shell: /bin/sh
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
    - unless: echo 'select * from agents limit 1;' | mysql -h{{ pillar['neutron']['dbserver'] }} -u{{ pillar['neutron']['dbuser'] }} -p{{ pillar['neutron']['dbpass'] }} {{ pillar['neutron']['dbname'] }}

neutron_user:
  keystone.user_present:
    - name: {{ pillar['neutron']['user'] }}
    - password: {{ pillar['neutron']['pass'] }}
    - email: {{ pillar['neutron']['email'] }}
    - tenant: service
    - roles:
      - service:
        - admin

neutron_service:
  keystone.service_present:
    - name: neutron
    - service_type: network
    - description: OpenStack Networking

neutron_endpoint:
  keystone.endpoint_present:
    - name: neutron
    - publicurl: http://{{ pillar['neutron']['server'] }}:9696
    - internalurl: http://{{ pillar['neutron']['server'] }}:9696
    - adminurl: http://{{ pillar['neutron']['server'] }}:9696
    - region: regionOne
    - require:
      - keystone: neutron_service
