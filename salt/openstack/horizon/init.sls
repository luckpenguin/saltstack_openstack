dashboard:
  pkg.installed:
    - pkgs:
      - openstack-dashboard
      - apache2
      - libapache2-mod-wsgi
      - memcached
      - python-memcache

/etc/openstack-dashboard/local_settings.py:
  file.managed:
    - source: salt://openstack/horizon/local_settings.py
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: dashboard

apache2:
  service.running:
    - watch:
      - file: /etc/openstack-dashboard/local_settings.py
    - require:
      - file: /etc/openstack-dashboard/local_settings.py

memcached:
  service.running:
    - require:
      - pkg: dashboard
