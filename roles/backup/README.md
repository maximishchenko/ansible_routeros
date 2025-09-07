Ansible RouterOS Backup
=========

This playbook can get backup and export file from RouterOS devices and send them into Telegram chat include groups with topics and encrypt backup files with GPG.

Requirements
------------

This playbook require any installed packages on Ansible control host:

- curl
- GPG
- python3-paramiko

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
  gather_facts: false
  roles:
     - { role: backup, type: export }
```

Create binary backup

```
- hosts: all
  connection: network_cli
  gather_facts: false
  roles:
     - { role: backup, type: backup }
```

License
-------

BSD

Author Information
------------------

Maxim Ishchenko <m.g.ishchenko@yandex.ru>
