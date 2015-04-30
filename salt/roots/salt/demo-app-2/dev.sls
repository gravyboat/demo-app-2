include:
  - python
  - python.virtualenv
  - git
  - users
  - groups
  - supervisor

demo_app_2_supervisor_conf:
  file.managed:
    - name: /etc/supervisord.d/demo-app-2-service.ini
    - source: salt://demo-app-2/files/demo-app-2-service.ini.jinja
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - template: jinja

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
