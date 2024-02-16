# Ansible Role: ADCS (Ludus)

An Ansible Role that installs [ADCS](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/active-directory-certificate-services-overview) on Windows Server and optionally configures [Certified Preowned](https://specterops.io/wp-content/uploads/sites/3/2022/06/Certified_Pre-Owned.pdf) templates.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    # This pulls the netbios_name out of the domain assigned to this machine in the ludus range config
    ludus_adcs_domain: "{{ (ludus | selectattr('vm_name', 'match', inventory_hostname))[0].domain.fqdn.split('.')[0] }}"
    # This pulls the hostname from the ludus config for this host
    ludus_adcs_ca_host: "{{ (ludus | selectattr('vm_name', 'match', inventory_hostname))[0].hostname }}"
    ludus_adcs_domain_username: "{{ ludus_adcs_domain }}\\{{ defaults.ad_domain_admin }}"
    ludus_adcs_domain_password: "{{ defaults.ad_domain_admin_password }}"
    ludus_adcs_ca_common_name: "{{ ludus_adcs_domain }}-CA"
    ludus_adcs_esc1: true
    ludus_adcs_esc2: true
    ludus_adcs_esc3: true
    ludus_adcs_esc3_cra: true
    ludus_adcs_esc4: true
    ludus_adcs_esc6: true
    ludus_adcs_esc8: true

## Dependencies

None.

## Example Playbook

```yaml
- hosts: adcs_hosts
  roles:
    - bad-sector-labs.ludus_adcs
  vars:
    ludus_adcs_domain: mydomain
    ludus_adcs_ca_host: CAHOST
    ludus_adcs_domain_username: "mydomain\\Administrator"
    ludus_adcs_domain_password: P@ssw0rd
    ludus_adcs_ca_common_name: mydomain-CA
    ludus_adcs_ca_web_enrollment: true
    ludus_adcs_esc1: true
    ludus_adcs_esc2: true
    ludus_adcs_esc3: true
    ludus_adcs_esc3_cra: true
    ludus_adcs_esc4: true
    ludus_adcs_esc6: true
    ludus_adcs_esc13: true
```

## Example Ludus Range Config

```yaml
ludus:
  - vm_name: "{{ range_id }}-ad-dc-win2022-server-x64-1"
    hostname: "{{ range_id }}-DC01-2022"
    template: win2022-server-x64-template
    vlan: 10
    ip_last_octet: 11
    ram_gb: 6
    cpus: 4
    windows:
      sysprep: true
    domain:
      fqdn: ludus.domain
      role: primary-dc
    roles:
      - bad-sector-labs.ludus_adcs
    role_vars:
      ludus_adcs_esc6: false
```


## License

GPLv3

Some code was based on tasks from [GOAD](https://github.com/Orange-Cyberdefense/GOAD) (also GPLv3).

The included [ADCSTemplate](https://github.com/GoateePFE/ADCSTemplate) project is licensed under the MIT license and written by Ashley McGlone.

## Author Information

This role was created in 2024 by [Bad Sector Labs](https://badsectorlabs.com/), for [Ludus](https://ludus.cloud/).
