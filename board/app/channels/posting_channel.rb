# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class PostingChannel < ApplicationCable::Channel
  # If HTTPS is to ActionCable, then the Controller is to the Channel
  #  (it handles a bunch of actions that the clientside JS sends)
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
    
    # first save the model (with proper sanitation)
    params = ActionController::Parameters.new(data)
    post = Post.new(params.permit(:title, :body))
    
    # then send it back to the clientside JS
    if post.save
      ActionCable.server.broadcast("posts_channel",
       elem: make_html_li_from_data(data["title"], data["body"]),
       count_elem: render_count_elem)
    else
      ActionCable.server.broadcast("posts_channel",
        state: "error")
    end
  end

  private
  # yes, we can just pass the JSON to the frontend but the Rails
  #  way is to let the server do the HTML generation because in
  #  theory the server should be faster at it than the clientside JS
  def make_html_li_from_data(title, body)
    "<li>#{title} : #{body}</li>"
  end
  
  # We should also probably do the method above using partials too so
  #  that we can use that template from elsewhere in the app
  def render_count_elem
    ApplicationController.render(partial: 'shared/count')
  end
end
