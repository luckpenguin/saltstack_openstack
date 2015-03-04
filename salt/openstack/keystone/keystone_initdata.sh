#!/bin/bash
export OS_SERVICE_TOKEN="{{ pillar['keystone']['keystone_admin_token'] }}"
export OS_SERVICE_ENDPOINT="http://{{ pillar['keystone']['keystone_server'] }}:35357/v2.0"

sleep 10

keystone tenant-create --name=admin --description="Admin Tenant"
keystone user-create --name=admin --pass="{{ pillar['keystone']['keystone_admin_pass'] }}"

keystone role-create --name=admin
keystone user-role-add --user=admin --tenant=admin --role=admin
#keystone user-role-add --user=admin --role=_member_ --tenant=admin

keystone tenant-create --name=demo
keystone user-create --name=demo --pass=demo
#keystone user-role-add --user=demo --role=_member_ --tenant=demo

keystone tenant-create --name service --description "Service Tenant"

keystone service-create --name=keystone \
--type=identity \
--description="Keystone Identity Service"

keystone endpoint-create \
--service-id=$(keystone service-list | awk '/ identity / {print $2}') \
--publicurl="http://{{ pillar['keystone']['keystone_server'] }}:5000/v2.0" \
--adminurl="http://{{ pillar['keystone']['keystone_server'] }}:35357/v2.0" \
--internalurl="http://{{ pillar['keystone']['keystone_server'] }}:5000/v2.0" \
--region regionOne

touch /var/lock/keystone/keystone-datainit.lock
