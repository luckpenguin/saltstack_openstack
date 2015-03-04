glance-mysql:
  mysql_database.present:
    - name: {{ pillar['glance']['dbname'] }}
    - require:
      - service: mysql
  mysql_user.present:
    - host: "{{ pillar['glance']['dbclienthost'] }}"
    - name: {{ pillar['glance']['dbuser'] }}
    - password: {{ pillar['glance']['dbpass'] }}
    - require:
      - mysql_database: glance-mysql
  mysql_grants.present:
    - grant: all
    - database: "{{ pillar['glance']['database'] }}"
    - user: {{ pillar['glance']['dbuser'] }}
    - host: "{{ pillar['glance']['dbclienthost'] }}"
