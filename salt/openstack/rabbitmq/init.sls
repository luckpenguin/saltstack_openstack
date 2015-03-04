rabbitmq-server:
  service.running:
    - require:
      - pkg: rabbitmq-server
  pkg:
    - installed
{% if grains['lsb_distrib_codename'] == 'wheezy' %}
  - require:
    - pkgrepo: install_rabbitmq-server
  pkgrepo.managed:
    - humanname: rabbitmq-server
    - name: deb http://www.rabbitmq.com/debian/ testing main
    - dist: testing
    - comps: main
    - file: /etc/apt/sources.list.d/rabbitmq.list
    - key_url: https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
{% endif %}



rabbit_user:
  rabbitmq_user.present:
    - name: {{ pillar['rabbitmq']['user'] }}
    - password: {{ pillar['rabbitmq']['password'] }}
    - force: False
    - tags: {{ pillar['rabbitmq']['tags'] }}
    - perms: 
      - '/': 
        - '.*'
        - '.*'
        - '.*'
    - require:
      - service: rabbitmq-server
