Installing and Using Paw with the FileThis API
===

To give you an idea of how to map your application's user workflows onto the FileThis API, we have created sequences of pre-configured API calls that you can step through manually. These simulate typical workflows for creating connections to document sources and let you observe the actual event notifications and document deliveries that result.

We use a Mac application called "Paw" and provide you with a document that contains replayable request sequences. 

##Download and install Paw

1. Download the installer from the [Paw website](https://luckymarmot.com/paw). Look for the “Try Paw” button to download the trial version.
1. Unzip the downloaded file.
1. Drag the application file into your Applications folder.


##Install the UUID Paw Extension

1. In the Paw application, from the "Paw" menu, choose the Extensions ---> Manage Extensions command.
2. In the dialog that is posed, search through the list of already-installed extensions on the left of the window for an item named "Generate Random UUID". If you see it, dismiss the dialog and go to the next section of this document. If you do not, click on the "Find More Extensions" button.
3. When you are taken to a page on the Paw website in your browser, use the search field to find the above-named extension.
4. Next to the extension, click the "Install Extension" button.
5. When you are returned to the Paw application, click the "Install" button to install the extension.


##Store your partner API key and API secret in your Mac's keychain

The Paw document does not contain the API key and secret strings that it will need in order to make requests agaist the FileThis API. Instead, these are stored outside the document in the system keychain on your Mac. If you have not already obtained these strings from us, let us know and we will get them to you by a secure method.

Follow these instructions to add the strings to your Mac keychain:

1. Launch the "Keychain Access" application. It lives in your Applications/Utilities folder.
2. From the "File" menu, choose the "New Password Item" command and observe that a dialog window is posed.
3. In the "Keychain Item Name", enter "FileThisPartnerApiSecret".
4. In the "Account Name" field, enter "production".
5. In the "Password" field, paste your API secret string.
6. Click the "Add" button.
2. From the "File" menu, choose the "New Password Item" command and observe that a dialog window is posed.
3. In the "Keychain Item Name", enter "FileThisPartnerApiKey".
4. In the "Account Name" field, enter "production".
5. In the "Password" field, paste your API key string.
6. Click the "Add" button.

At this point, you have securely saved your API key and secret. When you run requests using your Paw document, you may be asked for your login credentials in order for it to access the values in your keychain. You will have the opportunity to tell the keychain app to "always allow" access.


##Download and open our Paw document

1. Download the file from [here](https://dl.dropboxusercontent.com/u/3921769/FileThisPartner.paw).
1. Launch the Paw application.
1. Double-click the downloaded document to open it in Paw.
1. Observe that the requests are divided hierarchically into groups.


##Run the first workflow

1. Open the first group, named “Workflows”, by clicking the disclosure triangle next to it.
1. Observe that there are two sets of workflows, “Simple” and “User Interaction Required”. The first contains workflows that all result in documents being delivered as soon as a connection is created. The second contains workflows that require user-interaction to answer questions before documents are delivered.
1. Open the “Simple” group.
1. Observe that there are three workflows here, one for each type of document that FileThis can deliver, bills, statements and notices. All the workflows in this document use a fake website that is able to simulate what real sites do, like providing fake documents for delivery.
1. Open the “Get bill documents” group.
1. Observe that there are a number of actual request specifications here that represent a complete workflow. Executing these in sequence will result in documents being delivered to the configured endpoint.
1. Select the first request, named “Create account”.
1. From the “Request” menu, choose the “Send” command to execute the request.
1. Observe that request succeeds. If you choose the “JSON Text” item from the menu in the rightmost column, you will see what this request returns —the id of the created account, in this case.
1. Select the second request, named “Create a connection…” and execute it.
1. Observe that this request succeeds and returns the created connection’s id. At this point, the connection exists and a fetch operation has been started on our servers.
1. Select the third request, named “Read change notifications”, and execute it.
1. Observe that the results of this request displayed in the rightmost column is a list of notifications. You can execute this request multiple times and you’ll see new items appear at the top of the list and new actions occur. What you see here is determined by the subscriptions set in the partner console for your partner account. We assume you’ve already installed the console and are familiar with its operation. If you need help with this, let us know.
1. Observe that the connection state notifications change from “connecting” to “uploading” to “completed” as the fetch operation completes. Until you have your own server endpoint to receive these notifications, they will go to the “black hole” endpoint that is currently set for your account in the partner console.
1. Select the fourth request, named “Read document delivery records” and execute it.
1. Observe that this returns a list of documents delivered to your delivery endpoint. As with the change notifications, until you have your own server endpoint to receive these notifications, they will go to the “black hole” endpoint that is currently set for your account in the partner console. You can execute this request multiple times and watch as new documents are fetched and delivered.
1. Clean up by selecting the last request, named “Delete account" and executing it. Deleting the account will also delete the connection you created in it.

You can repeat the above steps for the “notices” and “bills” workflows if you like, but they’re essentially the same, differing only in that they deliver different document types. These may be useful in testing your endpoint when you want these different document types.


##Run the first workflow that requires user interaction

This, and the other user-interaction workflows simulate the additional steps that must happen when the website issues an authentication challenge that must be answered by the end user.

1. Open the top-level group named “Use interaction required”.
1. Observe that there are number of workflow there that all require some kind of input from the user.
1. Open the one called “Credentials Invalid Question”. This workflow simulates the case in which the user has initially supplied incorrect credentials for a website (or has changed his credentials on the site). When FileThis attempts to fetch documents, it discovers that the login credentials are incorrect, and creates a user-interaction request to get the right ones from the user.
1. Select the “Create account” request and execute it, observing that it succeeds.
1. Select the “Create connection…” request and execute it, observing that it succeeds.
1. Select the “Read change notifications” request and execute it repeatedly until you see a notification returned that an interaction was created. This entry will have a type of “created” and a resource pattern of the form: accounts/85651/connections/263158/interactions/1463931
1. Select the “Read user interactions” request and execute it.
1. Observe the contents of the response. This JSON is the user-interaction request that you’ll use later to build a GUI dialog to present to your user. Here we will simulate the correct response —as if the user entered the values in the dialog and as if your server returned a JSON response to the interaction request.
1. Select the "Respond to user interaction request with correct credentials” request and execute it.
1. Select the “Read change notifications” request and execute it repeatedly until you see a notification showing that the connection passed through the “uploading” state to the “completed” state.
1. Select the “Read document delivery records” request and execute it.
1. Observe that documents were delivered.
1. Clean up by selecting the last request, named “Delete account", and executing it.

You should repeat the above steps for the other workflows in the “User interaction required” group.

