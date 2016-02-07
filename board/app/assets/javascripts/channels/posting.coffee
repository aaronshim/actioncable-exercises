App.posting = App.cable.subscriptions.create "PostingChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log("Connected to the PostingChannel on the server")

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log("Disconnected from PostingChannel")

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log("Received something")
    $('#posts-list').append(data['elem'])

  post: (title, body) ->
    console.log("posting something")
    @perform 'post', title: title, body: body

###
$('#post-button').click ->
  console.log("Clicked post button!")
  App.posting.post("something", "here")
###