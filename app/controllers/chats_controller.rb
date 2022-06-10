class ChatsController < ApplicationController
  before_action :find_application
  before_action :find_chat, only: [:destroy]

  def index
    chats = @application.chats
    render json: chats, include: [:messages]
  end

  def create
    chat_number = @application.chats_count + 1

    @chat = Chat.new(
      number: chat_number,
      application: @application
    )

    if @chat.save
      # increase chats count
      @application.update({ chats_count: @application.chats_count + 1 })
      puts @application

      # return that new chat
      render json: { number: chat_number }
    else
      # return error
      render json: { 
        message: 'Unable to create new chat',
        error: @chat.errors.full_messages 
      }, status: 400
    end
  end

  def destroy
    if @chat
      # delete the chat if exists
      @chat.destroy
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
