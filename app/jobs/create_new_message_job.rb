class CreateNewMessageJob < ApplicationJob
  queue_as :default

  def perform(body, message_number, chat)
    message = Message.new({ body: body, number: message_number, chat: chat })
  
    if message.save
      chat.update({ messages_count: message_number })
    end
  end
end
