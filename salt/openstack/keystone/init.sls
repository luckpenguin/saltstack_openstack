keystone:
  pkg: 
    - installed
  service.running:
    - watch:
      - file: /etc/keystone/keystone.conf
      - cmd: keystone_init.sh
    - require:
      - file: /etc/keystone/keystone.conf
      - cmd: keystone_init.sh

/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://openstack/keystone/keystone.conf
    - user: keystone
    - group: keystone
    - mode: 640
    - template: jinja
    - require:
      - pkg: keystone

keystone_db_sync:
  cmd.run:
    - name: chown -R keystone:keystone /var/log/keystone/ && keystone-manage db_sync
    - cwd: /tmp/
    - user: root
    - shell: /bin/sh
    - require:
      - file: /etc/keystone/keystone.conf
    - unless: echo 'select * from user limit 1;' | mysql -h{{ pillar['keystone']['dbserver'] }} -u{{ pillar['keystone']['dbuser'] }} -p{{ pillar['keystone']['dbpass'] }} {{ pillar['keystone']['dbname'] }}

keystone_init.sh:
  cmd.script:
    - source: salt://openstack/keystone/keystone_init.sh
    - cwd: /tmp/
    - user: root
    - require:
      - file: /etc/keystone/keystone.conf
    - unless: test -f /var/lock/keystone/keystone-init.lock

Keystone_tenants:
  keystone.tenant_present:
    - names:
      - admin
      - demo
      - service
    - require:
      - service: keystone

Keystone_roles:
  keystone.role_present:
    - names:
      - admin
    - require:
      - service: keystone

admin:
  keystone.user_present:
    - password: {{ pillar['keystone']['admin_pass'] }}
    - email: {{ pillar['keystone']['email'] }}
    - roles:
      - admin:   # tenants
        - admin  # roles
      - service:
        - admin
    - require:
      - keystone: Keystone_tenants
      - keystone: Keystone_roles

keystone_service:
  keystone.service_present:
    - name: keystone
    - service_type: identity
    - description: Keystone Identity Service
    - require:
      - service: keystone

keystone_endpoint:
  keystone.endpoint_present:
    - name: keystone
    - publicurl: http://{{ pillar['keystone']['server'] }}:5000/v2.0
    - internalurl: http://{{ pillar['keystone']['server'] }}:5000/v2.0
    - adminurl: http://{{ pillar['keystone']['server'] }}:35357/v2.0
    - region: regionOne
    - require:
      - keystone: keystone_service
