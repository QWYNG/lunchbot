require_relative 'menu'
require_relative 'response'
require_relative 'request_parser'

class MessageHandler
  def initialize()
    @menu = Menu.new
    @request_parser = RequestParser.new
  end
  
  def handle(team_id, event_data)
    user_id = event_data['user']
    channel = event_data['channel']
    user_message = event_data['text']

    user_request = @request_parser.parse(user_message)

    if user_request == "menu"
      save_menu_url(user_message)
      bot_answer = "<!here> Menu has been set: #{@menu.url}"
      respondToMessage(bot_answer, team_id, user_id, channel)
    elsif user_request == "get_menu"
      bot_answer = "This week the menu is from: #{@menu.url}"
      respondToMessage(bot_answer, team_id, user_id, channel)
    else
      respondToMessage("This isn't a valid request", team_id, user_id)
    end
  end

  def respondToMessage(bot_answer, team_id, user_id, channel = user_id)
      response = Response.new(team_id, channel)
      response.send(bot_answer)
  end

  private
  
  def save_menu_url(text)
    url = @menu.parse_url(text)
    @menu.set_url(url)
  end
end