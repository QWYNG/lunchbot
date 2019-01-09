require 'bot'
require 'commands/crafter/add_office'
require 'mark_all_out'
require 'models/user'
require 'request_parser'
require 'requester'
require 'tiny_logger'
require 'user_info_provider'

class MessageHandler
  def initialize(args = {})
    @mark_all_out = args[:mark_all_out]
    @request_parser = RequestParser.new
    @bot = args[:bot]
  end

  def handle(requester)
    return unless requester.has_message?

    formated_data = format(requester)

    unless User.profile(requester.id)
      User.create(formated_data)
    end

    if !User.has_office?(requester.id) && !Commands::AddOffice.add_office_request?(formated_data)
      @bot.send("You need to add your office. ex: \"office: london\"", requester.recipient)
      return
    end

    returned_command = @request_parser.parse(formated_data)

    unless returned_command.nil?
      response = deal_with_command(returned_command)
      @bot.send(response, requester.recipient)
    end
  end

  private

  attr_reader :requester

  def deal_with_command(command)
    Logger.info("COMMAND RUN")
    response = command.run
    Logger.info("COMMAND RESPONSE: #{response}")
    response
  end

  def format(requester)
    {
      user_message: requester.message,
      user_id: requester.id,
      user_name: requester.name,
      user_email: requester.email,
      mark_all_out: @mark_all_out,
    }
  end
end
