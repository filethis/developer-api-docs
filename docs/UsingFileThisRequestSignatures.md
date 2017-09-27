Using FileThis Request Signatures
===

When FileThis makes requests to your service to send change event notifications and to deliver fetched documents, you need to authenticate and validate the data we send you. You need to know that:

1. The requests you receive do, in fact, come from our service, and not a bad guy.
2. The request data has not been tampered with by a bad guy while in transit.
3. The request is not be "replayed" by a bad guy.

You can meet these requirements by using the request signatures that we send in the headers of all requests we make to you. Before sending a request, we use your API secret, which is known to both your service and ours, to digitally sign the bits in the request body. We include this signature value, along with a timestamp, and a "nonce" value in request headers. When you receive the request, your code can create a signature of the bits and compare it to the one we sent you. If the signature you create does not match the one we sent you, you know that one of the three requirements listed above has not been met, and you will discard the request, possibly logging it as a hacking attempt.

To make it easier to understand what your code needs to do, we have written a Python language implementation of the algorithms. This is functioning code and you can use it as-is if you use Python. If you don't, you'll need to translate it and find a library that supports the creation of signatures using [Hash-based message authentication code](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code) (HMAC). You can find pointers to libraries for several languages [here](http://www.jokecamp.com/blog/examples-of-creating-base64-hashes-using-hmac-sha256-in-different-languages/).

As you’ll see in the code comments, you have a choice of three implementations, with increasing safety and slightly increasing code complexity. We recommend using the safest method, but the other two will also provide good security.

You can download the source code file from [here](https://filethis.slack.com/files/trent/F2JNKQX0E/request_validator.py)


