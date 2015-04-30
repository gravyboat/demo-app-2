base:
  '*':
    - users
    - sudoers
    - operations.pkgs
    - ntp
    - logrotate.salt
    - firewall

  'roles:demo-app-2-dev':
    - match: grain
    - demo-app-2.dev

  'roles:demo-app-2':
    - match: grain
    - demo-app-2
