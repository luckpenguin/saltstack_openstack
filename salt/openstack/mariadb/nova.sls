nova-mysql:
  mysql_database.present:
    - name: {{ pillar['nova']['dbname'] }}
    - require:
      - service: mysql
  mysql_user.present:
    - host: "{{ pillar['nova']['dbclienthost'] }}"
    - name: {{ pillar['nova']['dbuser'] }}
    - password: {{ pillar['nova']['dbpass'] }}
    - require:
      - mysql_database: nova-mysql
  mysql_grants.present:
    - grant: all
    - database: "{{ pillar['nova']['database'] }}"
    - user: {{ pillar['nova']['dbuser'] }}
    - host: "{{ pillar['nova']['dbclienthost'] }}"
