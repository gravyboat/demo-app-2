include:
  - python
  - python.virtualenv
  - git
  - users
  - groups
  - supervisor

create_demo_app_2_group:
  group.present:
    - name: demo-app-2-service

create_demo_app_2_user:
  user.present:
    - name: demo-app-2-service
    - groups:
      - demo-app-2-service
    - require:
      - group: create_demo_app_2_group

demo_app_2_supervisor_conf:
  file.managed:
    - name: /etc/supervisord.d/demo-app-2-service.ini
    - source: salt://demo-app-2/files/demo-app-2-service.ini.jinja
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - template: jinja

create_demo_app_2_opt:
  file.directory:
    - name: /opt/demo-app-2
    - user: demo-app-2-service
    - group: demo-app-2-service
    - mode: 755

{% if not 'dev' in grains['roles'] %}
checkout_demo_app_2_repo:
  git.latest:
    - name: https://github.com/gravyboat/salt-demo-2.git
    - target: {{ salt['pillar.get']('demo-app-2:app_root', '/home/vagrant/demo-app-2') }}
    - require:
      - user: create_demo_app_2_user
{% endif %}

demo_app_2_virtualenv:
  virtualenv.managed:
    - name: {{ salt['pillar.get']('demo-app-2:app_root', '/home/vagrant/demo-app-2') }}/env
    - user: {{ salt['pillar.get']('demo-app-2:user', 'vagrant') }}
    - python: /usr/bin/python2.7

upgrade_pip:
  pip.installed:
    - name: pip
    - bin_env:  {{ salt['pillar.get']('demo-app-2:app_root', '/home/vagrant/demo-app-2') }}/env
    - user: {{ salt['pillar.get']('demo-app-2:user', 'vagrant') }}
    - upgrade: True
    - require:
      - virtualenv: demo_app_2_virtualenv

install_demo_app_2_python_deps:
  pip.installed:
    - bin_env:  {{ salt['pillar.get']('demo-app-2:app_root', '/home/vagrant/demo-app-2') }}/env
    - user: {{ salt['pillar.get']('demo-app-2:user', 'vagrant') }}
    - requirements: {{ salt['pillar.get']('demo-app-2:app_root', '/home/vagrant/demo-app-2') }}/requirements.txt
    - require:
      - pip: upgrade_pip

start_demo_app_2_service_supervisor:
  supervisord.running:
    - name: demo-app-2-service
    - update: True
    - require:
      - pip: install_demo_app_2_python_deps
    - watch:
      - file: demo_app_2_supervisor_conf
