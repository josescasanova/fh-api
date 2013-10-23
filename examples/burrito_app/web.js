var express = require("express");
var connect = require("connect");
var OAuth = require("oauth").OAuth;
var MemoryStore = require('connect').session.MemoryStore;

var app = express();

// CONFIG -- change these settings for your app
// ======================================================================
var SELF_HOST = "" // your site

// get your keys from fancyhands.com/api/explorer
var API_CONSUMER_KEY = "" 
var API_CONSUMER_SECRET = ""

// ======================================================================

var API_HOST = "http://www.fancyhands.com";
var API_TEMP_URL  = API_HOST + "/api/oauth/temporary-credentials/";
var API_AUTH_URL  = API_HOST + "/api/oauth/authorize/";
var API_TOKEN_URL = API_HOST + "/api/oauth/token-credentials/";

app.use(express.logger());
app.use(express.cookieParser());
app.use(express.bodyParser());

app.use(express.session({cookie: { path: '/', 
				   httpOnly: true, 
				   maxAge: null}, 
			 secret:'ORRY CHEESE NOW'}));


app.use(express.static(__dirname + "/app"));
app.use("/styles/", express.static(__dirname + '/app/styles'));
app.use("/scripts/", express.static(__dirname + '/app/scripts'));
app.use("/views/", express.static(__dirname + '/views/scripts'));
app.use("/bower_components/", express.static(__dirname + '/app/bower_components'));

app.get('/login', function(req, response) {
    var oa = new OAuth(API_TEMP_URL,
		       API_TOKEN_URL,
	               API_CONSUMER_KEY,
	               API_CONSUMER_SECRET,
	               "1.0",
	               null,
	               "HMAC-SHA1");
    req.session.oa = oa;
    response.redirect("/");
});


app.get('/app', function(req, response) {
    if(!req.session.oa) {
	response.redirect('/login')
	return;
    }
    response.redirect('/')
});


var api_call = function(req, res) {
    connect.bodyParser();

    if(!req.session.oa) {
	res.send({'status': 'not logged in'})
	return;
    }  
  
    else {
	var method = req.body._method;
	var url = req.body._url;
	console.log("url: " + url);
	console.log("method: " + method);

	params = {}
	for(var k in req.body) {
	    if(k.indexOf('_') != 0) {
		params[k] = req.body[k];
	    }
	}

	var oa = new OAuth(req.session.oa._requestUrl,
			   req.session.oa._accessUrl,
			   req.session.oa._consumerKey,
			   req.session.oa._consumerSecret,
			   req.session.oa._version,
			   req.session.oa._authorize_callback,
			   req.session.oa._signatureMethod);
	var post_body = null;
	var post_content_type = null;

	oa._performSecureRequest(
	    "", 
	    "", 
	    method,
	    url,
	    params, 
	    post_body,
	    post_content_type, 
	    function(err, data, response) {
		if(err) {
		    console.log(err);
		    res.send({'status': 'failed'});
		    return;
		}
		res.send(data);
	    }
	);
    }

}

app.get('/api-call', api_call);
app.post('/api-call', api_call);

var port = process.env.PORT || 5000;
app.listen(port, '0.0.0.0', function() {
  console.log("Listening on " + port);
});
