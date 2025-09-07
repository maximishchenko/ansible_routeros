# Ansible playbooks for RouterOS

## Backup and export

This playbook can get backup and export file from RouterOS devices and send them into Telegram chat include groups with topics and encrypt backup files with GPG.


## Setup

1. Clone git repository

```shell
git clone git@github.com:maximishchenko/ansible_routeros.git
```

2. Copy sample inventory file to inventory

```shell
cp inventory/inventory.sample.yml inventory/inventory.yml
```

> You can also use make target create-inventory-file

```shell
make create-inventory-file
```

3. Modify inventory file. Example:

> In this example used group name sample with single host 0.0.0.1

```
all:
  children:
    sample:
      hosts:
        0.0.0.1:
```

4. For each group create file inside `group_vars`.

```
cp group_vars/sample.yml group_vars/group_name.yml
```

> You can also use make target create-group-template and input group name. 

```shell
make create-group-template
```

5. Modify each `group_vars` file with group specific values

6. Run playbook:

You can run playbook with pre-defined entrypoint `get_backup.yml` and pass extra-var type, value must be one of 'backup', 'export'

> Export config

```shell
ansible-playbook -i inventory/inventory.yml get_backup.yml -e type=export
```

> Full binary backup

```shell
ansible-playbook -i inventory/inventory.yml get_backup.yml -e type=backup
```

> You can use make target backup and pass TYPE variable value for passing to extra-var

> Export config

```shell
make backup TYPE=export
```

> Full binary backup

```shell
make backup TYPE=backup
```

6. Vault encryption

You can encrypt `group_vars` files with ansible-vault

Create file with encryption password. For example `.vaultpass` (exists at .gitignore)

```shell
echo "myverysecurestring" > .vaultpass
```

Set file permission


```shell
chmod 600 .vaultpass
```

Encrypt `group_vars` file with password stored inside `.vaultpass`

```shell
ansible-vault encrypt group_vars/group_name --vault-password-file=.vaultpass
```

For run playbook you must set --vault-password-file=.vaultpass

```shell
ansible-playbook get_backup.yml -e type=export --vault-password-file=.vaultpass
```

```shell
ansible-playbook get_backup.yml -e type=backup --vault-password-file=.vaultpass
```

You can also use make target `encrypt-group-vars`

```shell
make encrypt-group-vars
```

This target check .vaultpass exist. If file not exists will be asked for vault password and stored them in .vaultpass file.

Set permissions 0600 for `.vaultpass` file.

Every file in `group_vars` directory except `sample.yml` template will be encrypted with ansible-vault and password stored in `.vaultpass` file.

File will be encrypted only if not encrypted earlier.
