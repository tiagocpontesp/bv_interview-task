
assert = require 'assert'
nock = require 'nock'
request = require 'superagent'
mocked_reply = require './test.json'


describe 'interview task', ->

	base_url = 'http://localhost:8080'

	# start and wait for the local server
	before (done)->
		nock('http://www.betvictor.com').get('/live/en/live/list.json').reply 200, mocked_reply
		nock('http://www.betvictor.com').get('/live/de/live/list.json').reply 200, mocked_reply
		nock('http://www.betvictor.com').get('/live/it/live/list.json').reply 200, mocked_reply
		require('./main').on 'ready', done
	

	describe '/sports', ->
		it 'should list all sports, obeying list order as per the "pos" field', (done)->
			request.get("#{ base_url }/sports").end (res)->
				assert.equal res.ok, true, 'resp status NOK'
				assert.deepEqual res.body, [{id:1,title:'sport A'},{id:2,title:'sport B'}], 'resp body NOK'
				done()

	describe '/sports/<id>', ->
		it 'should list all events for a given sport, obeying list order as per the "pos" field', (done)->
			request.get("#{ base_url }/sports/1").end (res)->
				assert.equal res.ok, true, 'resp status NOK'
				assert.deepEqual res.body, [{"id":81,"title":"event 1A"},{"id":82,"title":"event 1B"}], 'resp body NOK'
				done()

	describe '/sports/<id>/events/<id>', ->
		it 'should list all outcomes for a given event', (done)->
			request.get("#{ base_url }/sports/2/events/92").end (res)->
				assert.equal res.ok, true, 'resp status NOK'
				assert.deepEqual res.body, [4,5,6], 'resp body NOK'
				done()
