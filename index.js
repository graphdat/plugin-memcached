var _param = require('./param.json');
var _os = require('os');
var _memcached = require('mc');

var _client = new _memcached.Client((_param.host || 'localhost') + ':' + (_param.port || 11211));

_client.connect(function(err)
{
	if (err)
	{
		console.error('connection error: %s', err);
		process.exit(1);
	}
});

var _pollInterval = _param.pollInterval || 1000;
var _source = _param.source || _os.hostname();

var _accum = {};

function accum(vals, name)
{
	var last = _accum[name];
	var cur = vals[name];

	if (last === undefined)
		last = cur;

	var diff = cur - last;

	_accum[name] = cur;

	return diff;
}

function poll()
{
	_client.stats(function(err, data)
	{
		if (err)
			return console.error(err);

		data = data[0];

		// Report
		console.log('MEMCACHED_ALLOCATED %d %s', data.bytes / data.limit_maxbytes, _source);
		console.log('MEMCACHED_CONNECTIONS %d %s', data.curr_connections, _source);
		console.log('MEMCACHED_HITS %d %s', accum(data, 'get_hits'), _source);
		console.log('MEMCACHED_MISSES %d %s', accum(data, 'get_misses'), _source);
		console.log('MEMCACHED_ITEMS %d %s', data.curr_items, _source);
		console.log('MEMCACHED_REQUESTS %d %s', accum(data, 'cmd_get') + accum(data, 'cmd_set'), _source);
		console.log('MEMCACHED_NETWORK_IN %d %s', accum(data, 'bytes_read'), _source);
		console.log('MEMCACHED_NETWORK_OUT %d %s', accum(data, 'bytes_written'), _source);
	});

	setTimeout(poll, _pollInterval);
}

poll();