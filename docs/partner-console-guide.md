## FileThisConnect Partner Guide

There are three integration points between your services and ours. In the first of these, you call us, and in the other two, we call you back:

1. The FileThis Content Delivery REST API
2. Our resource change notification service
3. Our document delivery service 

For anyone familiar with REST, reading through our [API documentation](https://filethis.com/doc/index.html) for #1 should make immediate sense. Resources have one or more of the familiar CRUD operations: (create, read, update and delete. Our resource types are things like FileThis user accounts (which you create on behalf of your users), document sources (eg. the "Bank of America" website), connections to sources (eg. A user's BofA checking account), and questions that are posed by sites (eg. "In what city were you born?").

The best way to become familiar with how the FileThisConnect Partner integration works, is to use our Partner Console app to set up your account and then to use it explore how document deliveries work. The rest of this page will walk you through this.

The FileThis Partner Console is used to configure and monitor the integration of your services and ours. It is an Adobe AIR application and runs on Mac, Windows and Linux platforms. To install it, please download it from [here](https://filethis.slack.com/files/U02B4SBE2/F30BR7P9N/filethispartnerconsole.air) and run the downloaded installer application. Note that on Windows, you may need to install the [Adobe AIR runtime](https://get.adobe.com/air/) first.

To use the Console, you must log in using a FileThis account. When you signed up as a FileThis Partner, we created two partner accounts for you, one for your production system and one for development. Each of these has an admin user account.


### Change your temporary partner admin account credentials

1. Log into the FileThis web client at https://sandbox.filethis.com
1. Click the little gray down arrow next to the "Hello" text in the upper-left corner of the window.
2. From the pulldown menu that appears, choose the *Profile* item.
2. In the dialog panel that appears, enter your actual email address and click the "OK" button.
3. Click the little gray down arrow again and select the *Security* item
3. Enter your old and new passwords, and click the *OK* button to confirm.

### Download and install the partner console

1. Download a copy of the console installer from [here](https://dl.dropboxusercontent.com/u/3921769/FileThisPartnerConsole.2014.10.30.air)
1. Launch the installer application
1. In the dialog that appears, note that the publisher is "Unknown" and there are warnings about the application having unrestricted access. You can safely ignore these. They appear because we have used a self-signed cert to sign this application's code.
1. Click the *Install* button on this dialog.
1. On the next dialog, choose an installation directory, or accept the default, and click the *Continue* button.
1. When the installer completes and quits, the console application will be launched automatically.

### Configure partner settings using the console

1. On the console application's login screen, enter the new FileThis partner account credentials you used above.
1. From the *Server* popup menu, choose the *sandbox.filethis.com* item.
1. Click the *Log In* button.
1. If the *Partner* tab is not selected, select it.
1. Optionally enter a different name in the *Name* field. This string is used for display purposes only.
1. In the *Domain Name* field enter your company domain name, if it is not already there.
1. Check the *Show Key and Secret* checkbox.
1. In the *API Secret* field, you may enter a new string. Alternatively, you may clear this field to tell our server to generate a new random string when you commit your changes. (Note that both the API Key and API Secret are encrypted in our database with a salt based on your admin account id)
1. In the *Delivery Receiver* field you will enter the URL to which FileThis delivers documents it fetches on behalf of your users. To start with, you may leave the default URL in place and use the PostTestServer.com endpoint for testing. Please be aware that documents delivered to this endpoint are not protected by any kind of access control and will be visible to anyone.
1. Commit your changes by clicking the *Update* button.

### Create and configure a notification subscriber

A subscriber record holds various settings that relate to the delivery of resource change notifications that FileThis sends to partners. You will likely have only one subscriber attached to your partner account. We've created a subscription for you, to get started, but the following explain how to create a new one.

**To create a subscriber:**

1. Click the *Subscribers* tab in the console.
1. In the lower panel, enter a name for your subscriber. (eg. "Main", or "Primary").
1. From the *State* popup menu, choose the *Ready* item.
1. The *Format* menu choose the *Chronological* item. The *Grouped" choice is deprecated.
1. Optionally override the default values for the change delivery retry intervals and socket timeout values.
1. In the *Receiver* field you will enter the URL of the webhook to which FileThis delivers notifications as the resources exposed by our API change. (eg. When a user's connection changes state to indicate that a website has posed a security question) To start with, you may leave the default URL in place and use the PostTestServer.com endpoint for testing. As with the document delivery endpoint, anything send to PostTestServer will be visible to anyone.
1. Click the *Create* button.
1. Observe that your new subscriber appears in the list above.
1. Click the refresh button (circular arrow icon) in the dark blue titlebar of the list panel and observe that the time in the *Checked* column advances. This manual method for refreshing the contents of panels in the console is used on the other tabs as well.

### Create and configure notification subscriptions

A subscription record declares your interest in some aspect of the state of the resources exposed by the FileThis API. Each subscription has a change type which can be one of: "Created", "Updated", or "Deleted". Each also has a resource pattern string that specifies which resources are of interest. This pattern closely matches the resource paths defined by our REST API. For example, the REST API lets you refer to a FileThis connection resource using a path of the form: _/accounts/123/connections/456_. That path refers to the connection with id *456* in the user account with id *123*. If you want to be notified when any user creates a new connection, you would create a subscription whose change type is *Created* and whose resource pattern is _/accounts/*/connections/*_. Note the use of asterisks as wildcards. When a change notification is sent to your subscriber's webhook receiver, the match string will include the actual id's for the matched resources. For example: _/accounts/111/connections/222_.

At the very least, you will need to be notified when user connections enter a state that requires you to interact with them through your UI. The state of a connection is not, strictly speaking, a resource. It's a property of a resource. In order to let you subscribe to changes to resource properties, we extend the REST resource path strings to include certain properties like this one. Conceptually, you might think of these as "sub-resources". A subscription that will tell FileThis to notify you about all changes in the state of connections would have a change type of *Updated* and the pattern: _/accounts/*/connections/*/state/*_. When a change notification is sent to your subscriber's webhook receiver, the match string will have the form: _/accounts/111/connections/222/state/question_, where *question* is a state that indicates that the user must answer a security question.

It happens that the connection state property can take on several values, not all of which will be of interest to you. To limit notifications to just those values, you should use a pattern that lists them explicitly: _/accounts/*/connections/*/state/question|answered|incorrect|error_. Note the use of vertical bar characters to denote alternative property values.

Again, we've pre-created a few subscriptions for you. The following explains how to create new ones.

**To create a subscription:**

1. Click the *Subscriptions* tab of the console.
1. Observe that the list of subscriptions is initially empty.
1. From the *Change Type* popup menu in the lower panel, make a choice (eg. *Created*)
1. In the *Resource Pattern* field, enter a pattern to match (eg. _/accounts/*/connections/*_)
1. Click the *Create* button.
1. Observe that the new subscription appears in the list above.


### Testing the delivery of change notifications and fetched documents

If you'd like to test that your configuration can be used to deliver documents and change notifications, follow [these instructions](using-postman.html) to install and set up the PostMan REST client and then return here to continue.

Ready? Let's use the PostMan collection to test your partner connections. We've pre-created a user account for you that has a single connection to a fake document source. You can easily create new accounts and new connections using the PostMan endpoints, but to start with, we will simply initiate a fetch with the one connection so we can see the delivery of change notifications and documents.

Assuming you've left the document delivery endpoint and the change notification endpoint for the PostTestServer service, those will be used in the following test.

Firstly, to get a list of all the current document sources (websites from which we fetch user documents), select the *GET /sources/* item and click the *Send* button in the right-sided panel. Observe that a JSON list of all sources is returned.

To see a list of all the user accounts that created by your partner account, select the *GET /accounts/* and click the *Send* button. You will see the single account we created for you. Note the "id" property of this account. We've used that in the other endpoints, as you will see.

To see a list of all the source connections created for this user account, select the *GET /accounts/{id}/connections/* endpoint and click the *Send* button. You will see a single connection which points at a PG&E test account.

To initiate a new fetch of all documents from this source, select the *POST /connections/{id}/fetch* endpoint and click the *Send* button.

Return the the FileThis Console app now and select the *Changes* tab. Click the the circular arrows to refresh the list and you will see the change notifications for this fetch as it happens. Keep refreshing and eventually you will see the *completed* state reached, indicating that the fetch was successful.

Click on the *Deliveries* tab and click on the fresh button, and you should see a list of documents that were delivered to the delivery endpoint.

**To verify that the change notifications were delivered**

1. Visit the PostTestServer page at: http://posttestserver.com/data/
1. Navigate to the information by the date it was received by first clicking on the year link, then the month link, then the day.
1. Search on the day page for the link named "ft-changes"
1. Click on one of the change notification links on this page.
1. Observe that the body of the recorded POST request contains the change information that corresponds to your change subscription patterns.

You can find pages for each delivered document in the same way, but look for the "ft-docs" link. Each entry for a document will contain JSON for the metadata associated with each document delivered, as well as the document file itself.

