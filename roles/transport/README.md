Transport
=========

Отвечает за транспорт файлов. Поддерживает следующие виды транспорта:
  - `Git репозиторий`
  >  Вне зависимости от значения параметра шифрования GPG в репозиторий попадут только нешифрованные файлы экспорта конфигураций
  - `FTP-сервер`
  - `Локальный каталог`
  > может быть как каталогом локальной файловой системы, так и примонтированным ресурсом, напимер SMB или NFS

Requirements
------------

Требует наличия следующих установленных пакетов на хосте управления Ansible:

- `curl`
- `git`

Для начальной настройки возможно использовать [setup_control_host.yml](setup_control_host.yml) или запустить ```make setup-control-host```

Role Variables
--------------

Все используемые переменные прокомментированы в шаблоне [group_vars/sample.yml](group_vars/sample.yml)

Example Playbook
----------------

```
- hosts: all
  connection: ansible.netcommon.network_cli
  roles:
    - role: transport
      transport_src: "/tmp/device.backup"
      transport_type: "backup"
```

License
-------

BSD

Author Information
------------------

Maxim Ishchenko <m.g.ishchenko@yandex.ru>
