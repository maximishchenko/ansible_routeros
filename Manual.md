### For ssh-key based authentication ssh-key must be added to ssh agent

```shell
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

### ansible collections installation

```shell
ansible-galaxy -i requirements.yml
```