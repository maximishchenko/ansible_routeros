# Ansible playbooks for RouterOS

## Backup and export

This playbook can get backup and export file from RouterOS devices and send them into Telegram group topic

1. Copy inventory.sample to inventory

```shell
cp inventory.sample inventory
```

2. Modify inventory file. Create group with IP addresses. Add group to `[ALL_RouterOS:children]`. Format:

```
[GroupName]
ip_address_1
ip_address_2
...
ip_address_N

[ALL_RouterOS:children]
```

3. For each group create file inside `group_vars`. For example:

```
touch group_vars/GroupName
```

> Read `group_vars/SAMPLE_RouterOS` and add group information into group file

4. Run playbook:

You can run playbook with entrypoints or directly `backup/main.yml` and pass extra variable


##### Entrypoints


> Export config

```shell
ansible-playbook get_export_config.yml
```

> Full binary backup

```shell
ansible-playbook get_binary_dump.yml
```

##### Arbuments

> Full binary backup

```shell
ansible-playbook backup/main.yml --extra-vars "action=backup"
```

> Export config

```shell
ansible-playbook backup/main.yml --extra-vars "action=export"
```
