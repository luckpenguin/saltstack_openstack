keystone-mysql:
  mysql_database.present:
    - name: {{ pillar['keystone']['dbname'] }}
    - require:
      - service: mysql
  mysql_user.present:
    - host: "{{ pillar['keystone']['dbclienthost'] }}"
    - name: {{ pillar['keystone']['dbuser'] }}
    - password: {{ pillar['keystone']['dbpass'] }}
    - require:
      - mysql_database: keystone-mysql
  mysql_grants.present:
    - grant: all
    - database: "{{ pillar['keystone']['database'] }}"
    - user: {{ pillar['keystone']['dbuser'] }}
    - host: "{{ pillar['keystone']['dbclienthost'] }}"
