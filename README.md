# saltstack_openstack
使用saltstack布署openstack juno，只支持ubuntu14.04
#使用
* 在controller,compute,network上安装ubuntu14.04-x86_64
* 配制salt
* git clone https://github.com/luckpenguin/saltstack_openstack
* mv saltstack_openstack /srv
* salt '*' saltutil.refresh_pillar
* salt '*' state.highstate -v
