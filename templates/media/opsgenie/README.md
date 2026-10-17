
# Opsgenie webhook 

This guide describes how to integrate your TAAE installation with Opsgenie using TAAE webhook feature. This guide provides instructions on setting up a media type, a user and an action in TAAE.

## In Opsgenie

1. Create an `API Key` following original instructions on how to [integrate API](https://docs.opsgenie.com/docs/api-integration).

2. Copy the `API Key` of your new integration to use it in TAAE.

## In TAAE

The configuration consists of a _media type_ in TAAE, which will invoke the webhook to send alerts to Opsgenie through the Opsgenie Rest API.

1. Create a global macro `{$ZABBIX.URL}` following instructions in [TAAE documentation](https://www.zabbix.com/documentation/7.4/manual/config/macros/user_macros)  with TAAE frontend URL - for example, `http://192.168.7.123:8081`.

[![](images/tn_1.png?raw=true)](images/1.png)

2. Import Opsgenie media type from this file [media_opsgenie.yaml](media_opsgenie.yaml) following instructions in [TAAE documentation](https://www.zabbix.com/documentation/7.4/manual/web_interface/frontend_sections/alerts/mediatypes). 

[![](images/tn_2.png?raw=true)](images/2.png)

3. Change the values of variables:
	* `opsgenie_api` (https://api.opsgenie.com/v2/alerts or https://api.eu.opsgenie.com/v2/alerts);
	* `opsgenie_web` (e.g., https://myzabbix.app.opsgenie.com);
	* `opsgenie_token`.

You can also set your own tags into `opsgenie_tags` as <comma_separated_list_of_tags> and team names into `opsgenie_teams` as <comma_separated_list_of_responders>.  
The priority level in `severity_default` will be used for non-triggered actions.

[![](images/tn_3.png?raw=true)](images/3.png)

For more information on TAAE webhook configuration, see [TAAE documentation](https://www.zabbix.com/documentation/7.4/manual/config/notifications/media/webhook).

To utilize the media type, it is recommended to create a dedicated TAAE user to represent Opsgenie.
See more details on creating [TAAE user](https://www.zabbix.com/documentation/7.4/manual/web_interface/frontend_sections/users/user_list).
Opsgenie user should suffice the default settings as this user will not be logging into TAAE. Note that in order to be notified about problems on a host, this user must have at least read permissions for this host.  
When configuring alert action, add this user in the _Send to users_ field (in Operation details) - this will tell TAAE to use Opsgenie webhook when sending notifications from this action.
Use the Opsgenie user in any actions of your choice. A text from "Action Operations" will be sent to "Opsgenie Alert" when the problem occurs. The text from "Action Recovery Operations" and "Action Update Operations" will be sent to "Opsgenie Alert Notes" when the problem is resolved or updated.

### Testing
Media testing can be done manually, from `Media types` page. Press `Test` button opposite to previously defined media type.
1. To create a problem following fields should be set:
    * event.subject = MEDIA TYPE TEST
    * event.id = 12345
    * event.source = 0 (it simulates trigger based event)
    * event.update.status = 0 (not an update operation)
    * event.value = 1 (this is a problem event)

    [![](images/tn_4.png?raw=true)](images/4.png)

2. Having successfully sent a request from TAAE, check if it is received in Opsgenie alert panel (it may require refreshing).
3. To close this problem from TAAE, change `event.value` to `0` (it indicates a recovery event) on the test page and press `Test` button again to send the problem close request.
4. Confirm that problem is closed in Opsgenie panel.

### Internal alerts
To receive notifications about an internal problem and recovery events in Opsgenie, mark the Custom message checkbox in the internal action configuration  and specify custom message templates for problem and recovery operations. 
If an internal action operation is configured without a custom message, the notification will not be sent. 
Note that this step is required only for notifications about internal events; for other event types specifying a custom message is optional. 

See more details on [Notifications upon events](https://www.zabbix.com/documentation/7.4/manual/config/notifications) in TAAE documentation and on [Alert API](https://docs.opsgenie.com/docs/alert-api) in Opsgenie documentation.

### Known issues

If both recovery and update operations are defined for an action and the problem is closed manually in the frontend, closing operation will be executed first.
Update operations for the resolved event will not be executed but the status of these operations will be changed to "Sent" in order to stop failed request attempts.

## Supported Versions

TAAE 7.4, Opsgenie Alert API.

## Feedback
Please report any issues with this media type at https://support.zabbix.com.
You can also provide feedback, discuss the template, or ask for help at TAAE forums.
