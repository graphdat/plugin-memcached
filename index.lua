local timer    = require('timer')
local boundary = require('boundary')
local io       = require('io')
local net      = require('net')


local __pgk        = "BOUNDARY MEMCACHED"
local client
local _previous    = {}
local host         = "127.0.0.1"
local port         = 11211
local pollInterval = 1000


if (boundary.param ~= nil) then
  pollInterval = boundary.param.pollInterval or pollInterval
  host          = boundary.param.host or host
  port          = boundary.param.port or port
  source             = (type(boundary.param.source) == 'string' and boundary.param.source:gsub('%s+', '') ~= '' and boundary.param.source) or
   io.popen("uname -n"):read('*line')
end


function berror(err)
  if err then print(string.format("%s ERROR: %s", __pgk, tostring(err))) return err end
end



function diff(a, b)
    if a == nil or b == nil then return 0 end
    return math.max(a - b, 0)
end


-- accumulate a value and return the difference from the previous value
function accumulate(key, newValue)
    local oldValue   = _previous[key] or newValue
    local difference = diff(newValue, oldValue)
    _previous[key]   = newValue
    return difference
end

-- init client
function init()
  if client == nil then
    client = net.createConnection(port, host, function (err)
      if berror(err) then end
    end)
  end
  client:on("error", function(err)
      berror(err)
  end)
  client:on("data", function(data)

      local d = {}
      for _, v in pairs(split(data, "\r\n")) do
        local s = v:gsub("STAT ", "")
        local t = {}
        for w in s:gmatch("%S+") do
          table.insert(t, w)
        end
        d[t[1]] = tonumber(t[2])
      end

      print(string.format('MEMCACHED_ALLOCATED %d %s', d.bytes / d.limit_maxbytes, source))
      print(string.format('MEMCACHED_CONNECTIONS %d %s', d.curr_connections, source))
      print(string.format('MEMCACHED_HITS %d %s', accumulate('get_hits', d.get_hits), source))
      print(string.format('MEMCACHED_MISSES %d %s', accumulate('get_misses', d.get_misses), source))
      print(string.format('MEMCACHED_ITEMS %d %s', d.curr_items, source))
      print(string.format('MEMCACHED_REQUESTS %d %s', accumulate('cmd_get', d.cmd_get) + accumulate('cmd_set', d.cmd_set), source))
      print(string.format('MEMCACHED_NETWORK_IN %d %s', accumulate('bytes_read', d.bytes_read), source))
      print(string.format('MEMCACHED_NETWORK_OUT %d %s', accumulate('bytes_written', d.bytes_written), source))
  end)

end


-- get the natural difference between a and b
function diff(a, b)
  if not a or not b then return 0 end
  return math.max(a - b, 0)
end

function split(str, delim)
   local res = {}
   local pattern = string.format("([^%s]+)%s()", delim, delim)
   while (true) do
      line, pos = str:match(pattern, pos)
      if line == nil then break end
      table.insert(res, line)
   end
   return res
end

print("_bevent:MEMCACHED plugin up : version 1.0|t:info|tags:memcached, lua, plugin")
init()

timer.setInterval(pollInterval, function ()
  client:write("stats " .. "\r\n")
end)




