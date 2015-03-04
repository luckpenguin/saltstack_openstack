nova_server:
  pkg.installed:
    - pkgs:
      - nova-api
      - nova-cert
      - nova-conductor
      - nova-consoleauth
      - nova-novncproxy
      - nova-scheduler
      - python-novaclient

/etc/nova/nova.conf:
  file.managed:
    - source: salt://openstack/nova_server/nova.conf
    - user: nova
    - group: nova
    - mode: 640
    - template: jinja
    - require:
      - pkg: nova_server

nova_services:
  service.running:
    - names:
      - nova-api
      - nova-cert
      - nova-consoleauth
      - nova-scheduler
      - nova-conductor
      - nova-novncproxy
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - file: /etc/nova/nova.conf

nova_db_sync:
  cmd.run:
    - name: nova-manage db sync
    - cwd: /tmp/
    - user: nova
    - shell: /bin/sh
    - require:
      - file: /etc/nova/nova.conf
    - unless: echo 'select * from instances limit 1;' | mysql -h{{ pillar['nova']['dbserver'] }} -u{{ pillar['nova']['dbuser'] }} -p{{ pillar['nova']['dbpass'] }} {{ pillar['nova']['dbname'] }}

nova_user:
  keystone.user_present:
    - name: {{ pillar['nova']['user'] }}
    - password: {{ pillar['nova']['pass'] }}
    - email: {{ pillar['nova']['email'] }}
    - tenant: service
    - roles:
      - service:
        - admin

nova_service:
  keystone.service_present:
    - name: nova
    - service_type: compute
    - description: OpenStack Compute

nova_endpoint:
  keystone.endpoint_present:
    - name: nova
    - publicurl: http://{{ pillar['nova']['server'] }}:8774/v2/%(tenant_id)s
    - internalurl: http://{{ pillar['nova']['server'] }}:8774/v2/%(tenant_id)s
    - adminurl: http://{{ pillar['nova']['server'] }}:8774/v2/%(tenant_id)s
    - region: regionOne
    - require:
      - keystone: nova_service
