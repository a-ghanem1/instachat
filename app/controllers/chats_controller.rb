class ChatsController < ApplicationController
  before_action :find_application
  before_action :find_chat, only: [:destroy]

  def index
    chats = @application.chats
    render json: chats, include: [:messages]
  end

  def create
    chat_number = $redis.get('chats' + @application.id.to_s).to_i

    if chat_number.nil?
      chat_number = @application.chats_count + 1
      $redis.set('chats' + @application.id.to_s, chat_number)
    end

    # add create new chat job to the queue
    CreateNewChatJob.perform_now(chat_number, @application)

    # return that new chat
    render json: { number: chat_number }
  end

  def destroy
    if @chat
      # delete the chat if exists
      @chat.destroy

      # update chats number
      @application.update({ chats_count: @application.chats_count - 1 })

      render json: { message:'Chat deleted successfully'}, status: 200
    else
      render json: { error: 'Unable to delete the chat' }, status:400
    end
  end

  private
  
  def find_application
    @application = Application.find_by(token: params[:application_token])

    if @application.nil?
      render error: { 
          message: 'Can not find the application with this specefic token'
        }, 
        status: 404
    end
  end

  def find_chat
    @chat = Chat.find(params[:id])

    if @chat.nil?
      render error: { 
          message: 'Can not find this chat'
        }, 
        status: 404
    end
  end
end
