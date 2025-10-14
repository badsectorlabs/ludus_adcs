# Ansible Role: ADCS (Ludus)

An Ansible Role that installs [ADCS](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/active-directory-certificate-services-overview) on Windows Server and optionally configures [Certified Preowned](https://specterops.io/wp-content/uploads/sites/3/2022/06/Certified_Pre-Owned.pdf) templates.

- Turns the VM assigned the "badsectorlabs.adcs" role into a Certificate Authority
- Optionally, creates certificate templates for ESC1,2,3,7,9, and 13
- Optionally, creates a user (`esc5user`) with rights over the CA's AD Object for ESC5
- Optionally, configures ATTRIBUTESUBJECTALTNAME2 on CA for ESC6
- Optionally, creates users (`esc7_camgr_user` and `esc7_certmgr_user`) to exploit ESC7
- Optionally, enables web enrollment for ESC8
- Optionally, creates a user (`esc9user`) with inbound GenericAll rights for ESC9
- Optionally, configures IF_ENFORCEENCRYPTICERTREQUEST on CA for ESC11
- Optionally, for ESC13, creates a user (`esc13user`), group (`esc13group`), template (`ESC13`), and Issuance policy (`IssuancePolicyForESC13`)
- Optionally, makes the `WebServer` template vulnerable to ESC15
- Optionally, configures szOID_NTDS_CA_SECURITY_EXT on CA and creates a user (`esc16user`) with inbound GenericAll rights for ESC16


> [!WARNING]
> This role is not idempotent! Setting a `ludus_adcs_escX` value to `true`, applying the role, then setting it to `false` and applying the role will *NOT* remove the template that is now set to `false`.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    # This pulls the netbios_name out of the domain assigned to this machine in the ludus range config
    ludus_adcs_domain: "{{ (ludus | selectattr('vm_name', 'match', inventory_hostname))[0].domain.fqdn.split('.')[0] }}"
    # This pulls the vm_name of the primary-dc for the domain assigned to this machine in the ludus range config
    ludus_adcs_dc: "{{ (ludus | selectattr('domain', 'defined') | selectattr('domain.fqdn', 'match', ludus_adcs_domain) | selectattr('domain.role', 'match', 'primary-dc'))[0].hostname }}"
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
    ludus_adcs_esc5: true
    ludus_adcs_esc6: true
    ludus_adcs_esc7: true
    ludus_adcs_esc8: true
    ludus_adcs_esc9: true
    ludus_adcs_esc11: true
    ludus_adcs_esc13: true
    ludus_adcs_esc15: true
    ludus_adcs_esc16: true

    # Vars for specific ESCs
    ludus_adcs_esc5_user: esc5user
    ludus_adcs_esc5_password: ESC5password

    ludus_adcs_esc7_ca_manager_user: esc7_camgr_user
    ludus_adcs_esc7_ca_manager_password: ESC7password
    ludus_adcs_esc7_cert_manager_user: esc7_certmgr_user
    ludus_adcs_esc7_cert_manager_password: ESC7password

    ludus_adcs_esc9_user: esc9user
    ludus_adcs_esc9_password: ESC9password

    ludus_adcs_esc13_user: esc13user
    ludus_adcs_esc13_password: ESC13password
    ludus_adcs_esc13_group: esc13group

    ludus_adcs_esc16_user: esc16user
    ludus_adcs_esc16_password: ESC16password

    # Template display name customization
    ludus_adcs_esc1_display_name: "ESC1"
    ludus_adcs_esc2_display_name: "ESC2"
    ludus_adcs_esc3_display_name: "ESC3"
    ludus_adcs_esc3_cra_display_name: "ESC3_CRA"
    ludus_adcs_esc4_display_name: "ESC4"
    ludus_adcs_esc7_display_name: "ESC7_CertMgr"
    ludus_adcs_esc9_display_name: "ESC9"
    ludus_adcs_esc13_display_name: "ESC13"

    ludus_adcs_template_display_names:
        ESC1: "{{ ludus_adcs_esc1_display_name }}"
        ESC2: "{{ ludus_adcs_esc2_display_name }}"
        ESC3: "{{ ludus_adcs_esc3_display_name }}"
        ESC3_CRA: "{{ ludus_adcs_esc3_cra_display_name }}"
        ESC4: "{{ ludus_adcs_esc4_display_name }}"
        ESC7_CERTMGR: "{{ ludus_adcs_esc7_display_name }}"
        ESC9: "{{ ludus_adcs_esc9_display_name }}"
        ESC13: "{{ ludus_adcs_esc13_display_name }}"


## Dependencies

None.

## Example Playbook

```yaml
- hosts: adcs_hosts
  roles:
    - badsectorlabs.ludus_adcs
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
    ludus_adcs_esc5: true
    ludus_adcs_esc6: true
    ludus_adcs_esc7: true
    ludus_adcs_esc8: true
    ludus_adcs_esc9: true
    ludus_adcs_esc11: true
    ludus_adcs_esc13: true
    ludus_adcs_esc15: true
    ludus_adcs_esc16: true
    # Rename templates (optional)
    ludus_adcs_template_display_names:
        ESC1: "WorkstationAuth"
        ESC2: "DocEncryption"
        ESC3: "EmployeeCert"
        ESC3_CRA: "EnrollmentAgent"
        ESC4: "LegacyApp"
        ESC7_CERTMGR: "Certmgr"
        ESC9: "ServerAuth"
        ESC13: "Smartcard" 
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
      - badsectorlabs.ludus_adcs
    role_vars:
      ludus_adcs_esc6: false # By default ESC1,2,3,4,5,6,7,8,9,11,13,15, and 16 are enabled
      # Rename templates (optional)
      ludus_adcs_template_display_names:
        ESC1: "WorkstationAuth"
        ESC2: "DocEncryption"
        ESC3: "EmployeeCert"
        ESC3_CRA: "EnrollmentAgent"
        ESC4: "LegacyApp"
        ESC7_CERTMGR: "Certmgr"
        ESC9: "ServerAuth"
        ESC13: "Smartcard"
```

## License

GPLv3

Some code was based on tasks from [GOAD](https://github.com/Orange-Cyberdefense/GOAD) (also GPLv3).

The included [ADCSTemplate](https://github.com/GoateePFE/ADCSTemplate) project is licensed under the MIT license and written by Ashley McGlone.

The inlcuded [PSPKI](https://github.com/PKISolutions/PSPKI/) project is licensed under the Microsoft Public License (Ms-PL) and written by Vadims Podans.

## Author Information

This role was created in 2024 by [Bad Sector Labs](https://badsectorlabs.com/), for [Ludus](https://ludus.cloud/).

Support for ESC5, ESC7, ESC9, ESC11, and ESC15 was added in November 2024, and ESC16 in May 2025 by [Brady McLaughlin](https://github.com/bradyjmcl).

Support for template name customization in October 2025 by [mojeda101](https://github.com/mojeda101).
