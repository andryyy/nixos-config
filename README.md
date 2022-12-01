## NixOS Configuration

Copy corresponding SSH key for secrets to `/etc/ssh/ssh_host_ed25519_key`.

```
~ sudo nixos-rebuild switch
```

### Modify or add secrets

```
~ sudo nano /etc/nixos/secrets/secrets.nix
```

Add new secret in the format of `"new-secret.age".publicKeys = [ default ];` if it does not exist yet.

This will define a new secret "new-secret" and encrypt it with the public keys defined as list (i.e. "default").

Modify or add content to the secret:

```
# "secrets.nix" is read from the current directory.
~ cd /etc/nixos/secrets
~ sudo EDITOR=/run/current-system/sw/bin/nano agenix -e new-secret.age --identity /etc/ssh/ssh_host_ed25519_key
```

1.1 Use secret as file to be read from

Use the new secret as file. Omit `.age` when defining the secret as config option:

```
  age.secrets.new-secret.file = secrets/new-secret.age;
```

Use the generated config as value for a file parameter, for example:

```
  passwordFile = config.age.secrets.new-secret.path;
```

1.2 Use secret as file to be placed in a given location

The decrypted secret file will be linked to the destination defined as path:

```
  age.secrets.new-secret = {
    file = secrets/new-secret.age;
    path = "/etc/some/config.conf";
    mode = "600";
    owner = "root";
    group = "root";
  };
```

