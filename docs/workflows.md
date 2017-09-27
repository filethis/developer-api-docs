We can dive into this more in our meeting, but I said I’d write up a description of the workflows that our connections go through and to highlight the ones that are not yet handled by your code. 

Once you make a request to our API to create a connection resource, your business logic should be driven primarily by the change notifications that result from the asynchronous processes that run within our services. Until now, your code has been polling to detect changed values. That will not scale well, and you have therefore been refactoring to use our change notifications instead.

In what follows, I divide the possible workflows into named scenarios and explain how each should be handled on your side.

These scenarios involve a couple of properties of our connection resource:

    state
    retries

Of these, the first one, "state" is relevant to all scenarios. This property goes through a sequence of values that reflect the fetching processes as they run on our system. Even if your code is not interested in every state transition, it's a good idea to subscribe using the wildcard pattern so that you'll have a complete picture of what's happening when you examine your logs:

    UPDATE  /accounts/*/connections/*/state/*

I notice that you currently subscribe only to transitions into the "waiting" state:

    UPDATE  /accounts/*/connections/*/state/waiting

I recommend changing this to use the wildcard and having your code ignore the states you don't care about, but logging them all. 


####Happy Path

What we call the “happy path” is a connection workflow that you're already handling (albeit by polling). When there are no challenge questions posed by the site we are fetching from and we succeed in getting documents, connections go through this sequence of states:

    waiting —> connecting —> uploading —>completed —> waiting

where “waiting” is the quiescent/resting state, “connecting” is when our fetcher is attempting to log into the site, and “uploading” is when we are getting documents from the site. While the connection is in the "uploading" state, you will receive deliveries of user documents, one by one, as we get them from the site.


####Challenge Question

When a site poses a challenge question (MFA), this must be conveyed to the user who must answer it in order for our fetching operation to continue and complete.

We have a separate issue to resolve concerning the fact that your code does not handle the full range of question types, but with that aside, this is a scenario that you are already handling.

Connections go through this initial sequence when a challenge question is encountered:

    waiting —> connecting —> question

At this point, we create a "user-interaction" resource which embodies the challenge question in a dynamic JSON record. Up until now, your code has been polling for the existence of a user-interaction record. You are refactoring to respond to a change notification instead using this subscription pattern:

    CREATED  /accounts/*/connections/*/interactions/*

When your code receives a notificatation that a user-interaction for the given connection has been created, it should pose the question to the user in your own user interface. Note that you will also receive a notification that the "state" property of the connection has transitioned to "question". You could use that to drive your logic instead, if you wanted.

When you obtain the answer from the user and send it back to us using the user-interaction request:

    PUT /v1/accounts/{accountId}/connections/{connectionId}/interactions/{interactionId}/response

the fetch operation resumes. If all goes well, the connection state will go through:

    question —> uploading —>completed —> waiting


####Retrying

This next scenario, and the ones that follow, are not yet being handled by your code. There are times when our Fetcher processes are unable to complete the fetch, for any number of reasons. When this happens, we retry the process over increasingly longer intervals of time until we either succeed, or fail after exceeding a maximum retry count and go into the "error" state, described in the next section.

Most of our other partners don't care that a connection does not immediately complete, so long as it eventually does. Because your product is very sensitive to any sort of delay, you will want to detect this scenario and decide how long you want to wait before falling back onto a manual upload of the document through your own UI. You may not want to wait for even the first retry attempt.

The connection state property goes through this initial sequence when an attempt to fetch does not work:

    waiting —> connecting —> waiting

In a future version of our API, we will add a "retrying" state to which your code can respond when it recieves a change notification. Until then, the value of another connection resource property, "retries", must be examined if you need to know that the fetch has not completed for this reason. This means that after you receive the notification that a connection has returned to the "waiting" state, you will need to request the connection resource and examine the value of the "retries" property. If this value is non-zero, you know that the fetch did not succeed yet. You will need to decide how many retries to wait for, if any.

The retry intervals are:

    2 hours
    24 hours
    24 hours
    24 hours
    
after which the connection goes into an "error" state, described next.

####Error

If we are unable to complete a fetch after several retries over a long period of time, we will put the connection into an "error" state. Because you have a subscription to the "state" property of connections, your code can respond specifically to the transition to this state.

Our service won't attempt to fetch from connections that have gone into an error state, but some of our partners allow their users to manually force a refetch for these. Sometimes, days later, a fetch will succeed, and the connection will return to a "waiting" state when it's done.

Because your product can't tolerate long delays, if you find that a connection has gone into an error state, you will want to fall back onto having your users manually upload the documents in your own UI.

####Question timeout

Some MFA questions posed by sites have a limited lifetime and won't be answerable once they expire. We sometimes refer to these as "non-persistent questions". A typical example is a one-time-authenication (OTA) code that is sent to a user's mobile phone via SMS. If the code is not returned within something like ten minutes, it will not be usable.

You may decide that waiting ten minutes is longer than you want to wait in any case. You may have your own timeout that will kick in, long before a question expires. If you do want to know that a question has expired, you can subscribe to the deletion of user-interaction resources:

    DELETED  /accounts/*/connections/*/interactions/*

If your code is waiting for the user to answer a pending user-interaction and you receive a notification that it has been deleted, you should remove the dialog and either fall back to a manual upload of the document, or force the connection to try the fetch again.

 
