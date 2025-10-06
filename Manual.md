### For ssh-key based authentication ssh-key must be added to ssh agent

```shell
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

### ansible collections installation

```shell
ansible-galaxy install -r requirements.yml
```

### Error: "'PlayContext' object has no attribute 'verbosity'"

```
ansible-galaxy collection list
```

```
ansible-galaxy collection install community.routeros --upgrade

```
