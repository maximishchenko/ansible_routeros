# Ansible playbooks for RouterOS

## Backup and export

This playbook can get backup and export file from RouterOS devices and send them into Telegram group topic

1. Clone git repository

```shell
git clone git@github.com:maximishchenko/ansible_routeros.git
```

2. Copy inventory.sample to inventory

```shell
cp inventory.sample inventory
```

3. Modify inventory file. Create group with IP addresses. Add group to `[ALL_RouterOS:children]`. Format:

```
[GroupName]
ip_address_1
ip_address_2
...
ip_address_N

[ALL_RouterOS:children]
```

4. For each group create file inside `group_vars`. For example:

```
touch group_vars/GroupName
```

> Read `group_vars/SAMPLE_RouterOS` and add group information into group file

5. Run playbook:

You can run playbook with entrypoints or directly `playbooks/backup/main.yml` and pass extra variable


##### Entrypoints


> Export config

```shell
ansible-playbook playbooks/get_export_config.yml
```

> Full binary backup

```shell
ansible-playbook playbooks/get_binary_dump.yml
```

##### Arguments

> Full binary backup

```shell
ansible-playbook playbooks/backup/main.yml --extra-vars "type=backup"
```

> Export config

```shell
ansible-playbook playbooks/backup/main.yml --extra-vars "type=export"
```

6. Vault encryption

You can encrypt `group_vars` files with ansible-vault

Create file with encryption password. For example .vaultpass (exists at .gitignore)

```shell
echo "myverysecurestring" > .vaultpass
```

Set file permission


```shell
chmod 600 .vaultpass
```

Encrypt `group_vars` file with password stored inside .vaultpass

```shell
ansible-vault encrypt group_vars/GroupName --vault-password-file=.vaultpass
```

For run playbook you must set --vault-password-file=.vaultpass

```shell
ansible-playbook playbooks/backup/main.yml --extra-args type=export --vault-password-file=.vaultpass
```
