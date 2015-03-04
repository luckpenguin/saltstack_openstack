neutron-mysql:
  mysql_database.present:
    - name: {{ pillar['neutron']['dbname'] }}
    - require:
      - service: mysql
  mysql_user.present:
    - host: "{{ pillar['neutron']['dbclienthost'] }}"
    - name: {{ pillar['neutron']['dbuser'] }}
    - password: {{ pillar['neutron']['dbpass'] }}
    - require:
      - mysql_database: neutron-mysql
  mysql_grants.present:
    - grant: all
    - database: "{{ pillar['neutron']['database'] }}"
    - user: {{ pillar['neutron']['dbuser'] }}
    - host: "{{ pillar['neutron']['dbclienthost'] }}"
