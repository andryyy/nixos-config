# Secrets that will be decrypted to a specific path
# Files exist as sym links

{
  age.secrets.user-github-SSH-key = {
    file = ../secrets/github-SSH-key.age;
    path = "/home/user/.ssh/github_key";
    mode = "600";
    owner = "user";
    group = "users";
  };

  age.secrets.root-github-SSH-key = {
    file = ../secrets/github-SSH-key.age;
    path = "/root/.ssh/github_key";
    mode = "600";
    owner = "root";
    group = "root";
  };

  age.secrets.ssh-config-root = {
    file = ../secrets/ssh-config-root.age;
    path = "/root/.ssh/config";
    mode = "600";
    owner = "root";
    group = "root";
  };

  age.secrets.nl-SSH-key = {
    file = ../secrets/nl-SSH-key.age;
    path = "/root/.ssh/nl.key";
    mode = "600";
    owner = "root";
    group = "root";
  };

  age.secrets.DebianHomeserver-SSH-key = {
    file = ../secrets/DebianHomeserver-SSH-key.age;
    path = "/root/.ssh/DebianHomserver.key";
    mode = "600";
    owner = "root";
    group = "root";
  };

  age.secrets.smb-secrets = {
    file = ../secrets/smb-secrets.age;
    path = "/etc/samba/smb-secrets";
    mode = "600";
    owner = "root";
    group = "root";
  };

  age.secrets.NetworkManager-HAI = {
    file = secrets/NetworkManager-HAI.age;
    path = "/etc/NetworkManager/system-connections/hai-wifi.nmconnection";
    mode = "600";
    owner = "root";
    group = "root";
  };
}
