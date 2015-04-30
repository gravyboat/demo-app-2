base:
  '*':
    - groups
    - users
    - python
    - firewall

  'roles:demo-app-2':
    - match: grain
    - demo-app-2

  'roles:demo-app-2-dev':
    - match: grain
    - demo-app-2-dev
