Storage
=========

This playbook can send backup or export files from RouterOS devices to any storages.
Supports:
  - FTP
  - Folder (can be local folder or mounted resource, such as SMB or NFS)

Requirements
------------

This playbook require any installed packages on Ansible control host:

- curl

For initial setup you can use setup_control_host.yml playbook or run make target setup-control-host

Role Variables
--------------

All variables are commented inside group sample template file in group_vars/sample.yml

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
- hosts: all
  connection: network_cli
  roles:
    - role: storage
      storage_src: "/tmp/device.backup"
      storage_type: "backup"
```

License
-------

BSD

Author Information
------------------

Maxim Ishchenko <m.g.ishchenko@yandex.ru>
