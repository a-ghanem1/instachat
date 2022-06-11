class CreateNewChatJob < ApplicationJob
  queue_as :default

  def perform(chat_number, application)
    chat = Chat.new({ number: chat_number, application: application })

    if chat.save
      application.update({ chats_count: chat_number })
    end
  end
end
