ntp:
  pkg: 
    - installed
    - name: ntp
  service.running:
    - watch:
      - file: ntp
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://openstack/ntp/ntp.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ntp

