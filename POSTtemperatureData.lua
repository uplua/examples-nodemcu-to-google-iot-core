local HOST = "http://cloudiotdevice.googleapis.com"

local URI = "/v1/projects/luabigquery/locations/us-central1/registries/registry1/devices/esp32:publishEvent"

function build_post_request(host, uri)

    request = "POST "..uri.." HTTP/1.1\r\n"..
    "Host: "..host.."\r\n"..
    "Connection: close\r\n"..
    "Content-Type: application/json\r\n"..
    "authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpYXQiOjE1NjQwMjQ5OTcsImV4cCI6MTU2NDAyODU5NywiYXVkIjoibHVhYmlncXVlcnkifQ.nSVblhCyLgpf0PxUCawZ097F6Zd8H0k9H_8OaXIQcQRQquMDpwo9TMWGoKAaS8GeteBJMHLtGlmfGPOgJkPrnA\r\n"..
    "cache-control: no-cache\r\n"..
    "{'binary_data':'aZVsbG8K'}"

    print(request)

    return request
end


local function display(sck, response)
    print(response)
end

local function send_data()

    socket = net.createConnection(net.TCP,0)
    socket:on("receive",display)
    socket:connect(80,HOST)

    socket:on("connection",function(sck)

        local post_request = build_post_request(HOST, URI)
        sck:send(post_request)
    end)
end

function check_wifi()
    local ip = wifi.sta.getip()

    if (ip==nil) then
        print("Connecting...")
    else
        tmr.stop(0)
        print("Connected to AP!")
        print(ip)
        -- send post request to google cloud iot core
        send_data()
    end

end

tmr.alarm(0,7000,1,check_wifi)
