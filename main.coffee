
EventEmitter = require('events').EventEmitter
http = require 'http'
express = require 'express'
request = require 'superagent'
_ = require 'lodash'


port = 8080
langs = ['en','de','it']
caches = {}
refresh_caches_period = 1*60*1000


app = express()
app.use express.compress()


app.use (req,res,next)->
	if req.acceptedLanguages.length == 0
		req.cache = caches[langs[0]]
	else
		for al in req.acceptedLanguages
			if al in langs
				req.cache = caches[al]
				break
	if !req.cache?
		res.status(404).end()
	else
		next()


app.get '/sports', (req,res)->
	ordered_sports = _.sortBy req.cache.sports, 'pos'
	result = _.map ordered_sports, (s)->
		id: s.id
		title: s.title
	res.json result

app.get '/sports/:id', (req,res)->
	sport = _.find(req.cache.sports, id:+req.param('id'))
	ordered_events = _.sortBy sport?.events, 'pos'
	result = _.map ordered_events, (e)->
		id: e.id
		title: e.title
	res.json result

app.get '/sports/:sport_id/events/:event_id', (req,res)->
	sport = _.find(req.cache.sports, id:+req.param('sport_id'))
	event = _.find(sport?.events, id:+req.param('event_id'))
	result = event?.outcomes
	res.json result


module.exports = new EventEmitter()

ready = _.after langs.length, _.once ->
	http.createServer(app).listen(port)
	console.log "port #{ port } is up."
	module.exports.emit('ready')

refresh_caches = ->
	for lang in langs
		((lang)->
			request.get("http://www.betvictor.com/live/#{ lang }/live/list.json").end (res)->
				# console.log "#{lang} : #{res.body}"
				caches[lang] = res.body if res.ok
				ready()
		)(lang)
refresh_caches()
setInterval refresh_caches, refresh_caches_period
