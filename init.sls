{% set remote_hosts = pillar['ssh-tunnel']['remote-hosts'] %}

{%- macro ssh_tunnel_user(fullname, username, ssh_pubkey) %}
{{ username }}:
  user.present:
    - fullname: {{ fullname }}
    - shell: /bin/bash
    - home: /home/{{ username }}

/home/{{ username }}/.ssh:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - mode: 755
    - require:
      - user: {{ username }}

/home/{{ username }}/.ssh/authorized_keys:
  file.managed:
    - user: {{ username }}
    - group: {{ username }}
    - mode: 644
    - contents:
      # Allow SSH tunneling to 1.postgresql.reporting only
      - no-pty,no-user-rc,no-agent-forwarding,no-X11-forwarding,{% for host in remote_hosts %}permitopen="{{ host }}",{% endfor %}command="/bin/echo do-not-send-commands" {{ ssh_pubkey }}
    - require:
      - user: {{ username }}
{%- endmacro %}

{% for username, attr in pillar['ssh-tunnel']['users']|dictsort %}
{{ ssh_tunnel_user(attr['name'], username, attr['pubkey']) }}
{% endfor %}
