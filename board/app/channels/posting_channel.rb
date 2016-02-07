# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class PostingChannel < ApplicationCable::Channel
  def subscribed
    # set the name of the stream to stream from when
    # the clientside js subscribes to this channel
    stream_from "posts_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def post(data)
    # when the action 'post' is called clientside, this
    #  happens serverside
    ActionCable.server.broadcast("posts_channel",
     elem: make_html_li_from_data(data["title"], data["body"]))
  end

  private
  # yes, we can just pass the JSON to the frontend but the Rails
  #  way is to let the server do the HTML generation because in
  #  theory the server should be faster at it than the clientside JS
  def make_html_li_from_data(title, body)
    "<li>#{title} : #{body}</li>"
  end
end
