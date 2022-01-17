{% set minion_data = salt['mine.get']('*', 'grains.item') %}

{% for username, data in pillar['ssh-tunnel']|dictsort %}

{{ username }}:
  user.present:
    - fullname: {{ data['fullname'] }}
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
      # Allow SSH tunneling only to hosts registered with salt-master
      {% for pubkey in data['pubkeys'] %}
      - no-pty,no-user-rc,no-agent-forwarding,no-X11-forwarding,{% for host, data in minion_data.items() %}permitopen="{{ data['fqdn'] }}:22",{% endfor %}command="/bin/echo do-not-send-commands" {{ pubkey }}
      {% endfor %}
    - require:
      - user: {{ username }}

{% endfor %}
