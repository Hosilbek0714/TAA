# User guide to setting up TAAE monitoring of the Morningstar products

TAAE provides a powerful automated solution for monitoring the state of Morningstar products. For example, if the device battery voltage is too low or a battery temperature drops below a given threshold, the system will generate an alert and send it to your preferred notification channel (e-mail/phone/Jira/Slack/or many others). The full list of alerts depends on the device - see the individual template documentation for details. This guide explains how to get TAAE and configure the software for monitoring.

## Pre-requisites and installation

TAAE is an open-source product that can be installed on a majority of Unix-like distributions at no cost  - see [full list of supported distributions](https://www.zabbix.com/download). Alternatively, TAAE is available on certain [cloud services](https://www.zabbix.com/cloud_images).

1. Install TAAE following instructions from the [downloads page](https://www.zabbix.com/download) for your preferred installation method.  

2. Download monitoring templates suitable for your Morningstar products to the computer.

3. Supported Morningstar products

| Product | Readme | Template |
|---|---|---|
| Prostar MPPT | [Readme](morningstar_prostar_mppt_snmp/README.md) | [Template](morningstar_prostar_mppt_snmp/template_net_morningstar_prostar_mppt_snmp.yaml) |
| Prostar PWM | [Readme](morningstar_prostar_pwm_snmp/README.md) | [Template](morningstar_prostar_pwm_snmp/template_net_morningstar_prostar_pwm_snmp.yaml) |
| Sunsaver MPPT | [Readme](morningstar_sunsaver_mppt_snmp/README.md) | [Template](morningstar_sunsaver_mppt_snmp/template_net_morningstar_sunsaver_mppt_snmp.yaml) |
| Suresine | [Readme](morningstar_suresine_snmp/README.md) | [Template](morningstar_suresine_snmp/template_net_morningstar_suresine_snmp.yaml) |
| Tristar MPPT 600V | [Readme](morningstar_tristar_mppt_600V_snmp/README.md) | [Template](morningstar_tristar_mppt_600V_snmp/template_net_morningstar_tristar_mppt_600V_snmp.yaml) |
| Tristar MPPT | [Readme](morningstar_tristar_mppt_snmp/README.md) | [Template](morningstar_tristar_mppt_snmp/template_net_morningstar_tristar_mppt_snmp.yaml) |
| Tristar PWM | [Readme](morningstar_tristar_pwm_snmp/README.md) | [Template](morningstar_tristar_pwm_snmp/template_net_morningstar_tristar_pwm_snmp.yaml) |

## TAAE set up

1. Log in to TAAE.

1. Using a sidebar menu at the left, navigate to the *Configuration -> Templates* section.
Import the downloaded template into TAAE by following these steps:

- Press the *Import* button in the top right corner
- Select the YAML file of the required template on your machine
- Press *Import*

1. Now you need to teach TAAE how to connect to the device.
To do so, first create a host to represent your Morningstar device:

- Using a sidebar menu at the left, navigate to the _Configuration -> Hosts_ section
- Press the *Create host* button in the top right corner
- In the Host configuration window fill in the required fields:

  - *Host name* -  enter any unique name
  - *Groups* - select an existing host group or enter the name of a new group to be created
  - *Interfaces* - press Add and select SNMP from the drop-down list that appears.

- Add an SNMP interface for the host:
  - Enter the IP address/DNS name and port number
  - Select the SNMP v2 from the dropdown
  - In the *SNMP community* field enter 'public'
  - Turn off the *Use bulk requests* checkbox because devices do not work correctly in this mode
- Open the *Templates* tab. In the *Link new templates* field, start typing Morningstar, then select the imported template from the list.

1. Repeat step 3 for each Morningstar device you want to monitor.

By now, TAAE is configured to generate alerts if something goes wrong with the device. The alerts will be displayed in the TAAE dashboard. If you would like to receive notifications about problems by e-mail, phone, or some other channel, follow instructions for configuring [notifications upon events](https://www.zabbix.com/documentation/7.2/manual/config/notifications) provided in TAAE documentation.
