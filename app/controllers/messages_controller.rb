class MessagesController < ApplicationController
  before_action :verify_application
  before_action :find_chat

  def index
    render json: @chat.messages
  end

  def search
    if params[:term].nil?
      @messages = []
    else
      @messages = Message.search(params[:term], @chat.id)
    end

    render json: @messages
  end
  def create
    message_number = $redis.get('messages' + @chat.id.to_s).to_i

    if message_number.nil?
      message_number = @chat.messages_count + 1
      $redis.set('messages' + @chat.id.to_s, message_number)
    end

    # add create new message to the queue
    CreateNewMessageJob.perform_now(params[:body], message_number, @chat)

    # return that new chat
    render json: { number: message_number }
  end

  private
  
  def verify_application
    @application = Application.find_by(token: params[:application_token])

    if @application.nil?
      render error: { 
          message: 'Can not find the application with this specefic token'
        }, 
        status: 404
    end
  end

  def find_chat
    @chat = Chat.find_by(number: params[:chat_number])

    if @chat.nil?
      render error: { 
          message: 'Can not find this chat'
        }, 
        status: 404
    end
  end
end
