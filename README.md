## Betvictor interview task

### Usage
	     npm install
	     npm test
	     npm start

### Worthy of note
 - I hope you don't mind my use of coffeescript. If it's bothersome, let me know and I'll convert it into a typical readable JS.
 - You seem to use the URL to very practically parametrize the language, but since the intended API URLs were already present in the enunciate and the accept-language header is more RESTful, I used that instead. I would like to point out that I'm no radical with these matters, and have no objections to your method.
 - I've included a basic in-process caching feature which limits the amount of requests to the origin server to once per minute. On a production service however, the endpoints' replies should be the ones that get cached. I'd go for a redis cache with pathname+lang as key if that was the case.
 - Other things to look at on production would be the HTTP caching headers, runtime parametrization with env variables instead of the hard-coded defaults at the top (e.g. port), and better status codes for misguided clients (e.g.: try asking for outcomes of an unexisting event).
