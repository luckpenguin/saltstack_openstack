glance:
  pkg: 
    - installed

glance-api:
  service.running:
    - watch:
      - file: /etc/glance/glance-api.conf
    - require:
      - file: /etc/glance/glance-api.conf

/etc/glance/glance-api.conf:
  file.managed:
    - source: salt://openstack/glance/glance-api.conf
    - user: glance
    - group: glance
    - mode: 640
    - template: jinja
    - require:
      - pkg: glance

glance-registry:
  service.running:
    - watch:
      - file: /etc/glance/glance-registry.conf
    - require:
      - file: /etc/glance/glance-registry.conf

/etc/glance/glance-registry.conf:
  file.managed:
    - source: salt://openstack/glance/glance-registry.conf
    - user: glance
    - group: glance
    - mode: 640
    - template: jinja
    - require:
      - pkg: glance

glance_db_sync:
  cmd.run:
    - name: glance-manage db_sync
    - cwd: /tmp/
    - user: glance
    - shell: /bin/sh
    - require:
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-registry.conf
    - unless: echo 'select * from images limit 1;' | mysql -h{{ pillar['glance']['dbserver'] }} -u{{ pillar['glance']['dbuser'] }} -p{{ pillar['glance']['dbpass'] }} {{ pillar['glance']['dbname'] }}

glance_user:
  keystone.user_present:
    - name: {{ pillar['glance']['user'] }}
    - password: {{ pillar['glance']['pass'] }}
    - email: {{ pillar['glance']['email'] }}
    - tenant: service
    - roles:
      - service:
        - admin

glance_service:
  keystone.service_present:
    - name: glance
    - service_type: image
    - description: OpenStack Image Service

glance_endpoint:
  keystone.endpoint_present:
    - name: glance
    - publicurl: http://{{ pillar['glance']['server'] }}:9292
    - internalurl: http://{{ pillar['glance']['server'] }}:9292
    - adminurl: http://{{ pillar['glance']['server'] }}:9292
    - region: regionOne
    - require:
      - keystone: glance_service
