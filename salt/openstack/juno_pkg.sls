{% if grains['lsb_distrib_codename'] == 'wheezy' %}
juno-backports:
    pkgrepo.managed:
        - humanname: juno-backports
        - name: deb http://archive.gplhost.com/debian juno-backports main
        - dist: juno-backports
        - comps: main
        - file: /etc/apt/sources.list.d/gplhost.list
        - key_url: http://ftp.gplhost.com/debian/repository_key.asc


juno:
    pkgrepo.managed:
        - humanname: juno-backports
        - name: deb http://archive.gplhost.com/debian juno main
        - dist: juno
        - comps: main
        - file: /etc/apt/sources.list.d/gplhost.list
        - key_url: http://ftp.gplhost.com/debian/repository_key.asc
        - require:
            - pkgrepo: juno-backports
{% endif %}

{% if grains['oscodename'] == 'trusty' %}
ubuntu-cloud-keyring:
  pkg.installed

cloud-archive_juno:
  pkgrepo.managed:
      - humanname: cloud-archive_juno
      - name: deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/juno main
      - dist: trusty-updates/juno
      - comps: main
      - file: /etc/apt/sources.list.d/cloudarchive-juno.list
      - require:
          - pkg: ubuntu-cloud-keyring
{% endif %}
