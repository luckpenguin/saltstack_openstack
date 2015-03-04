{% if grains['lsb_distrib_codename'] == 'wheezy' %}
install_mariadb-server:
  pkg: 
    - installed
    - name: mariadb-server
    - require:
      - pkgrepo: install_mariadb-server
  pkgrepo.managed:
    - humanname: mariadb-server
    - name: deb http://debian.ustc.edu.cn/mariadb/repo/5.5/debian wheezy main
    - dist: wheezy
    - comps: main
    - file: /etc/apt/sources.list.d/maradb.list
    - keyid: cbcb082a1bb943db
    - keyserver: keyserver.ubuntu.com
{% endif %}

{% if grains['lsb_distrib_codename'] == 'trusty' %}
install_mariadb-server:
  pkg: 
    - installed
    - name: mariadb-server
    - require:
      - pkgrepo: install_mariadb-server
  pkgrepo.managed:
    - humanname: mariadb-server
    - name: deb http://debian.ustc.edu.cn/mariadb/repo/5.5/ubuntu trusty main
    - dist: trusty
    - comps: main
    - file: /etc/apt/sources.list.d/maradb.list
    - keyid: cbcb082a1bb943db
    - keyserver: keyserver.ubuntu.com
{% endif %}

/etc/mysql/conf.d/mariadb.cnf:
  file.managed:
     - name: /etc/mysql/conf.d/mariadb.cnf
     - source: salt://openstack/mariadb/mariadb.cnf
     - user: root
     - group: root
     - mode: 644
     - require:
       - pkg: install_mariadb-server

/etc/mysql/my.cnf:
  file.managed:
     - name: /etc/mysql/my.cnf
     - source: salt://openstack/mariadb/my.cnf
     - user: root
     - group: root
     - mode: 644
     - require:
       - pkg: install_mariadb-server

mysql:
  service.running:
  - require:
    - file: /etc/mysql/my.cnf
  - watch:
    - file: /etc/mysql/conf.d/mariadb.cnf
    - file: /etc/mysql/my.cnf
