Ansible RouterOS Backup
=========

This playbook can get backup and export file from RouterOS devices and downloaded them for temporaty directory.

Requirements
------------

This playbook require any installed packages on Ansible control host:

- ansible-pylibssh

For initial setup you can use setup_control_host.yml playbook or run make target setup-control-host

Role Variables
--------------

All variables are commented inside group sample template file in group_vars/sample.yml

Example Playbook
----------------

Create export configuration

```
- hosts: all
  connection: network_cli
  roles:
    - role: backup
      backup_type: "{{ type }}"
```

Create binary backup

```
- hosts: all
  connection: network_cli
  roles:
     - { role: backup, type: backup }
```

License
-------

BSD

Author Information
------------------

Maxim Ishchenko <m.g.ishchenko@yandex.ru>
