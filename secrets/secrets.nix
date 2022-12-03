let
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmT++YnUKhh4mMi80J/H4xbf5l+65GVg+eu0G3nQtY6";
in
{
  "passwordFile.age".publicKeys = [ default ];
  "NetworkManager-HAI.age".publicKeys = [ default ];
  "DebianHomeserver-SSH-key.age".publicKeys = [ default ];
  "nl-SSH-key.age".publicKeys = [ default ];
  "github-SSH-key.age".publicKeys = [ default ];
  "ssh-config-root.age".publicKeys = [ default ];
  "wireguard-privateKey.age".publicKeys = [ default ];
  "smb-secrets.age".publicKeys = [ default ];
}
