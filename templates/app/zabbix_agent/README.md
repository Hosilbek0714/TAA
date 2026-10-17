
# TAAE agent

### Macros used

|Name|Description|Default|
|----|-----------|-------|
|{$AGENT.TIMEOUT}|<p>Timeout after which agent is considered unavailable. Works only for agents reachable from TAAE server/proxy (passive mode).</p>|`3m`|

### Items

|Name|Description|Type|Key and additional info|
|----|-----------|----|-----------------------|
|Version of TAAE agent running||TAAE agent|agent.version<p>**Preprocessing**</p><ul><li><p>Discard unchanged with heartbeat: `1d`</p></li></ul>|
|Host name of TAAE agent running||TAAE agent|agent.hostname<p>**Preprocessing**</p><ul><li><p>Discard unchanged with heartbeat: `1d`</p></li></ul>|
|TAAE agent ping|<p>The agent always returns "1" for this item. May be used in combination with `nodata()` for the availability check.</p>|TAAE agent|agent.ping|
|TAAE agent availability|<p>Used for monitoring the availability status of the agent.</p>|TAAE internal|zabbix[host,agent,available]|

### Triggers

|Name|Description|Expression|Severity|Dependencies and additional info|
|----|-----------|----------|--------|--------------------------------|
|TAAE agent is not available|<p>For passive agents only, host availability is used with `{$AGENT.TIMEOUT}` as a time threshold.</p>|`max(/TAAE agent/zabbix[host,agent,available],{$AGENT.TIMEOUT})=0`|Average|**Manual close**: Yes|

# TAAE agent active

### Macros used

|Name|Description|Default|
|----|-----------|-------|
|{$AGENT.NODATA_TIMEOUT}|<p>No data timeout for active agents. Consider to keep it relatively high.</p>|`30m`|
|{$AGENT.TIMEOUT}|<p>Timeout after which agent is considered unavailable.</p>|`5m`|

### Items

|Name|Description|Type|Key and additional info|
|----|-----------|----|-----------------------|
|Version of TAAE agent running||TAAE agent (active)|agent.version<p>**Preprocessing**</p><ul><li><p>Discard unchanged with heartbeat: `1d`</p></li></ul>|
|Host name of TAAE agent running||TAAE agent (active)|agent.hostname<p>**Preprocessing**</p><ul><li><p>Discard unchanged with heartbeat: `1d`</p></li></ul>|
|TAAE agent ping|<p>The agent always returns "1" for this item. May be used in combination with `nodata()` for the availability check.</p>|TAAE agent (active)|agent.ping|
|Active agent availability|<p>Availability of active checks on the host. The value of this item corresponds to availability icons in the host list.</p><p>Possible values:</p><p>0 - unknown</p><p>1 - available</p><p>2 - not available</p>|TAAE internal|zabbix[host,active_agent,available]|

### Triggers

|Name|Description|Expression|Severity|Dependencies and additional info|
|----|-----------|----------|--------|--------------------------------|
|TAAE agent is not available|<p>For active agents, `nodata()` with `agent.ping` is used with `{$AGENT.NODATA_TIMEOUT}` as a time threshold.</p>|`nodata(/TAAE agent active/agent.ping,{$AGENT.NODATA_TIMEOUT})=1`|Average|**Manual close**: Yes|
|Active checks are not available|<p>Active checks are considered unavailable. Agent has not sent a heartbeat for a prolonged time.</p>|`min(/TAAE agent active/zabbix[host,active_agent,available],{$AGENT.TIMEOUT})=2`|High||

## Feedback

Please report any issues with the template at [`https://support.zabbix.com`](https://support.zabbix.com)

You can also provide feedback, discuss the template, or ask for help at [`TAAE forums`](https://www.zabbix.com/forum/zabbix-suggestions-and-feedback)

