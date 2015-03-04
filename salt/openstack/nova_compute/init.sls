nova-compute:
  pkg.installed: []
  service.running:
    - watch:
      - file: /etc/nova/nova.conf
    - require:
      - file: /etc/nova/nova.conf

/etc/nova/nova.conf:
  file.managed:
    - source: salt://openstack/nova_compute/nova.conf
    - user: nova
    - group: nova
    - mode: 640
    - template: jinja
    - require:
      - pkg: nova-compute

/etc/nova/nova-compute.conf:
  file.managed:
    - source: salt://openstack/nova_compute/nova-compute.conf
    - user: nova
    - group: nova
    - mode: 640
    - template: jinja
    - require:
      - pkg: nova-compute
