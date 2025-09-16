Role Name
=========

A brief description of the role goes here.

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

```
- hosts: all
  connection: network_cli
  roles:
    - role: report
      attach: "{{ tmp_path }}"
      caption: "{{ report_caption }}"
```

License
-------

BSD

Author Information
------------------

Maxim Ishchenko <m.g.ishchenko@yandex.ru>
