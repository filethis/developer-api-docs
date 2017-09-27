Installing and Using Postman with the FileThis API
===

To give you an idea of how to map your application's user workflows onto the FileThis API, we have created sequences of pre-configured API calls that you can step through manually. These simulate typical workflows for creating connections to document sources and let you observe the actual event notifications and document deliveries that result.

We use a cross-platform application called "Postman" and provide you with a document that contains replayable request sequences. 

##Download and install Postman

1. Download the Postman desktop application installer for your development platform from the [Postman website](https://www.getpostman.com/apps).
1. Run the downloaded installer application.
1. Launch the Postman application.

##Download and import the FileThis collection file

1. Download the FileThis Postman collection file from [here](https://dl.dropboxusercontent.com/u/3921769/FileThisPostmanCollection.json).
1. In the Postman application, click the "Import" button located on the upper left of the main window.
2. In the dialog that is posed, either drag the downloaded collection file into the "Import File" panel, or use the "Choose Files" button to navigate to it in your filesystem.
3. Observe that the column on the left of the main window now contains a number of folders.

##Download and import the FileThis environment file

1. Download the FileThis Postman environment file from [here](https://dl.dropboxusercontent.com/u/3921769/FileThisPostmanEnvironment.json).
1. In the Postman application, click the gear icon button located at the upper right of the main window and select the "Manage Environments" command from the popup menu.
2. In the "Manage Environments" dialog that is posed, click the "Import" button located at the bottom right of the window.
3. In the "Import Environment" dialog, click the "Choose File" button and navigate to the downloaded environment file.
4. Observe that there is now a "FileThis" environment item in the "Manage Environments" dialog.


##Store your partner API key and API secret in Postman

The requests in the FileThis collection refer to variables in the Postman environment that contain your FileThis API key and secret. In order for these requests to work, you need to fill in the values of these environment variables. If you have not already obtained your API key and secret strings from us, let us know and we will get them to you by a secure method.

Follow these instructions to add these strings to your Postman environment:

1. With the "Manage Environments" window open (see above), click the "FileThis" environment name.
2. Observe that there are a number of variables in this environment. Among them are "api-key" and "api-secret".
3. Click on the value field for each of these variables and paste in your key and secret.
4. Click the "Update" button to save your changed values.


##Run a simple workflow

1. In the left-hand column of the Postman application, open the "FileThis Workflows" collection by selecting it.
2. Observe that a number of named workflow folders appear below the collection name.
3. Select the "Get bill documents" folder.
4. Observe that a sequence of requests appear below the folder name.
5. Select the first request, named "Create account".
6. Observe that information about this request appears in the right-side panel.
7. Click the blue "Send" button.
8. Observe that the request succeeds and returns a response that contains the FileThis id of the created account resource.
9. Click the eyeball icon button at the upper right corner of the Postman window.
10. Observe that the environment variable named "accountId" now contains the id of the newly-created account. This will be used by subsequent requests in this workflow.
11. From the left-side request list, select the "Create connection to fake source (bills)" item.
12. Click the blue "Send" button.
13. Observe that the request succeeds and that the id of the created connection is returned in the response. A value for an environment variable called "connectionId" will have been added for this. At this point, the connection exists and a fetch operation has been started on our servers.
14. Select the "Read change notifications" request item and click the blue "Send" button.
15. Observe that the current chronological list of change notifications is returned. You can execute this request multiple times and you’ll see new items appear at the top of the list and new actions occur. What you see here is determined by the subscriptions set in the partner console for your partner account. We assume you’ve already installed the console and are familiar with its operation. If you need help with this, let us know.
16. Observe that the connection state notifications change from “connecting” to “uploading” to “completed” as the fetch operation completes. Until you have your own server endpoint to receive these notifications, they will go to the “black hole” endpoint that is currently set for your account in the partner console.
17. Select the request named “Read document delivery records” and click the "Send" button.
18. Observe that this returns a list of documents delivered to your delivery endpoint. As with the change notifications, until you have your own server endpoint to receive these notifications, they will go to the “black hole” endpoint that is currently set for your account in the partner console. You can execute this request multiple times and watch as new documents are fetched and delivered.
19. Clean up by selecting the last request, named “Delete account" and executing it. Deleting the account will also delete the connection you created in it.


##Run a workflow that requires user interaction

Some workflows require interaction with the end-user to handle things like challenge questions that websites can pose. The user-interaction workflows in this Postman collection simulate the back-and-forth between the user, your service, our service, and the website.

1. In the left-hand column of the Postman application, open the "FileThis Workflows" collection and select the folder named "Credentials Invalid Question". This workflow simulates the case in which the user has initially supplied incorrect credentials for a website (or has changed his credentials on the site itself). When FileThis attempts to fetch documents, it discovers that the login credentials are incorrect, and creates a user-interaction request to get the right ones from the user.
2. Select the first request, named "Create account" and click "Send", observing that it succeeds.
3. Select the second request, named "Create connection to fake source..." and click "Send", observing that it succeeds.
1. Select the request named “Read change notifications” and click the "Send" button repeatedly until you see a notification returned that an interaction was created. This entry will have a type of “created” and a resource pattern of the form: accounts/85651/connections/263158/interactions/1463931
1. Select the “Read user interactions” request and send it.
1. Observe the contents of the response. This JSON is the user-interaction request that you’ll use later to build a GUI dialog to present to your user. Here we will simulate the correct response —as if the user entered the values in the dialog and as if your server returned a JSON response to the interaction request.
1. Select the "Respond to user interaction request with correct credentials” request and send it.
1. Select the “Read change notifications” request and send it repeatedly until you see a notification showing that the connection passed through the “uploading” state to the “completed” state.
1. Select the “Read document delivery records” request and send it.
1. Observe that documents were delivered.
1. Clean up by selecting the last request, named “Delete account", and sending it.



