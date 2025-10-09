# Ansible playbooks for RouterOS.

> Автоматизация управления сетевыми устройствами на базе Mikrotik Router OS.

## Резервное копирование устройств.

### Описание

Для организации резервного копирования устройств под управлением RouterOS предназначен плейбук [get_backup.yml](get_backup.yml).

Производит резервное копирование как в формат бинарного файла с расширением `.backup`, так и экспорт конфигурации в текстовый файл с расширением `.rsc`.

Имеется возможность шифрования файлов резервный копий с помощью GPG.

Поддерживает следующие способы хранения резервных копий:

- Хранение в локальном каталоге на управляющем хосте Ansible (может быть примонтированным каталогом SMB или NFS)
- Отправка файлов на FTP сервер
- Отправка файлов по Email
- Отправка файлов в группу Telegram с учетом наличия различных тем в группе

> Активация или отключение любого способа хранения регулируется соответствующим параметром в файле конфигурации группы устройств (`group_vars`)


### Установка

1. Клонировать репозиторий

```shell
git clone git@github.com:maximishchenko/ansible_routeros.git
```

> Для унификации процесса развертывания каждый шаг имеет цель в [Makefile](Makefile). Требует установки приложения make

2. Скопировать файл инвентаризации из шаблона [inventories/sample/hosts.yml](inventories/sample/hosts.yml), например в файл с именем `inventories/hosts.yml`

Возможно 2 варианта:

- С использованием цели [Makefile](Makefile) `create-inventory-file`. Будет создан файл `inventories/hosts.yml` на базе шаблона [inventories/sample/hosts.yml](inventories/sample/hosts.yml) без учета комментариев

```shell
make create-inventory-file
```
- С использованием команды shell

```shell
cp inventories/sample/hosts.yml inventories/hosts.yml
```
3. Добавить адреса управляемых устройств в inventory-файл. Пример:

```yml
all:
  children:
    sample:
      hosts:
        0.0.0.1:
```

> В примере используется группа `sample` с единственным хостом `0.0.0.1`

4. Для каждой группы устройств необходимо создать файл с установленными значениями переменных в каталоге [group_vars/](group_vars/).

Возможно 2 варианта:

- С использованием цели [Makefile](Makefile) `create-group-template`. В процессе выполнение запросит название группы, создаст копию шаблона [group_vars/sample.yml](group_vars/sample.yml) без учета комментариев с именем файла, который совпадает с введенным именем группы 

```shell
make create-group-template
```

- С использованием команды shell

```shell
cp group_vars/sample.yml group_vars/group_name.yml
```
5. Отредактировать каждый файл в каталоге [group_vars/](group_vars/) и указать значения переменных, специфичные для соответствующей группы.

6. Единоразово запустить плейбук, отвечающий за настройку хоста управления Ansible [setup_control_host.yml](setup_control_host.yml), при запросе ввести пароль `sudo`

Возможно 2 варианта:

- С использованием цели [Makefile](Makefile) `setup-control-host`.

```shell
make setup-control-host
```

- С использованием команды shell

```shell
ansible-playbook setup_control_host.yml --ask-become-pass
```

### Описание используемых переменных

### Шифрование файлов

Т.к. файлы резервных копий устройств и экспорта конфигураций могут быть переданы через общедоступные средства связи (например электронная почта или чат Telegram), то предусмотрена возможность дополнительного шифрования файлов с использованием GPG.

Необходимость шифрования, а также адрес электронной почты и ключ шифрования указываются в нижеприведенных параметрах соответственно:

- `encryption_common.is_enabled`
- `encryption_common.gpg_key_email`
- `encryption_common.gpg_secret_key`

> Ключ шифрования GPG должен быть установлен на управляющем хосте Ansible.

### Шифрование файлов с данными групп устройств

Т.к. файлы, содержащие значения переменных для групп устройств содержат персональную информацию (например пароль от SMTP-сервера или Telegram Bot Token), то необходимо также шифровать данные файлы с использованием Ansible Vault.

Возможно 2 варианта запуска процесса шифрования файлов внутри каталога [group_vars/](group_vars/)

- С использованием цели [Makefile](Makefile) `encrypt-group-vars`. Будет проверено наличие в корневом каталоге проекта файла `.vault.pass` (исключен в [.gitignore](.gitignore)), если файл отсутствует - запросит ввод пароля, запишет в файл `.vault.pass`, установит права 0600 и зашифрует все файлы внутри каталога [group_vars/](group_vars/), кроме [group_vars/sample.yml](group_vars/sample.yml). При этом будет проверен каждый файл и будут зашифрованы, только в случае, если не был зашифрован ранее.

```shell
make encrypt-group-vars
```

- С использованием набора команд shell

Создать файл, который будет содержать ключ шифрования Ansible Vault. Например `.vault.pass` (исключен в [.gitignore](.gitignore))

```shell
echo "myverysecurestring" > .vault.pass
```

Установить права 0600 на файл `.vault.pass`


```shell
chmod 600 .vault.pass
```

Зашифровать файл внутри каталога [group_vars/](group_vars/) ключом шифрования, сохраненным в файле `.vault.pass`

```shell
ansible-vault encrypt group_vars/group_name --vault-password-file=.vault.pass
```

При запуске с использование shell команд необходимо дополнительно передавать путь к файлу `.vault.pass` в значении параметра `--vault-password-file`: 
 `--vault-password-file=.vault.pass`

Пример
```shell
ansible-playbook get_backup.yml -i inventories/hosts.yml -e type=export --vault-password-file=.vault.pass
```

```shell
ansible-playbook get_backup.yml -i inventories/hosts.yml -e type=backup --vault-password-file=.vault.pass
```

### Создание полной резервной копии

Процесс создания полной резервной копии устройства учитывает возможности Router OS по шифрованию файла резервной копии.

Для управления параметрами шифрования используются следующие переменные:

- `backup_binary_dump.is_encrypted` - Если установлено значение True, то резерная копия будет зашифрована штатным механизмом шифрования RouterOS. Иначе резервная копия будет незашифрована.
- `backup_binary_dump.password` - Позволяет задать собственный пароль шифрования. Если значение не указано или `False`, но при этом `backup_binary_dump.is_encrypted` имеет значение `True`, то будет использован штатный механизм шифрования, т.е. паролем шифрования будет пароль пользователя устройства от имени которого создается резервная копия.

Возможно 2 варианта запуска процесса создания полной резервной копии.

- С использованием цели [Makefile](Makefile) `backup`, необходимо передать переменную TYPE со значением, равным `backup`. При этом будет запущен плейбук `get_backup.yml` для inventory-файла `inventories/hosts.yml` и передано значение `backup` для extra-параметра `type`

```shell
make backup TYPE=backup
```

> В случае, если необходимо использовать inventory-файл, отличный от `inventories/hosts.yml`, необходимо дополнительно передать переменную `INVENTORY` со значением, равным пути к соответствующему файлу

```shell
make backup TYPE=backup INVENTORY=inventories/inventory.custom.yml
```

- С использованием команды shell

```shell
ansible-playbook -i inventories/hosts.yml get_backup.yml -e type=backup
```

### Экспорт конфигурации

Процесс создания экспорта конфигурации учитывает возможности Router OS, касающиеся включения или исключения чувствительных данных (например паролей учетных записей).

Для управления данным поведением используется параметр `backup_export_config.is_sensitive`.

Возможно 2 варианта запуска процесса создания полной резервной копии.

- С использованием цели [Makefile](Makefile) `backup`, необходимо передать переменную TYPE со значением, равным `export`. При этом будет запущен плейбук `get_backup.yml` для inventory-файла `inventories/hosts.yml` и передано значение `export` для extra-параметра `type`

```shell
make backup TYPE=export
```
> В случае, если необходимо использовать inventory-файл, отличный от `inventories/hosts.yml`, необходимо дополнительно передать переменную `INVENTORY` со значением, равным пути к соответствующему файлу

```shell
make backup TYPE=export INVENTORY=inventories/inventory.custom.yml
```

- С использованием команды shell

```shell
ansible-playbook -i inventories/hosts.yml get_backup.yml -e type=export
```


