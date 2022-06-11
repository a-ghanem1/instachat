class CreateNewChatJob < ApplicationJob
  queue_as :default

  def perform(chat_number, application)
    chat = Chat.new({ number: chat_number, application: application })

    if chat.save
      application.update({ chats_count: chat_number })

      $redis.incr('chats' + application.id.to_s)
    end
  end
end
