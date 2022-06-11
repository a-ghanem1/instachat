class CreateNewMessageJob < ApplicationJob
  queue_as :default

  def perform(body, message_number, chat)
    Message.create({ body: body, number: message_number, chat: chat })
  end
end
