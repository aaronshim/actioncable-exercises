import websocket
import sys
import json
import time

# This script takes the two arguments given to it to send a post over websockets to our Rails ActionCable server

# we use the websocket-client python library here

# open a websocket connection and subscribe to our channel
ws = websocket.create_connection("ws://localhost:3000/cable")
cmd = {"command" : "subscribe", "identifier" : json.dumps({"channel": "PostingChannel"})}
ws.send(json.dumps(cmd))

# give ample time for subscription confirmation
time.sleep(2)

# get ready to post our thing (format reverse-engineered)
data = {"title" : sys.argv[1], "body" : sys.argv[2], "action" : "post"}
cmd["command"] = "message"
cmd["data"] = json.dumps(data)
ws.send(json.dumps(cmd))

# give ample time for request to go through
time.sleep(2)
ws.close()
