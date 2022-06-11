class CreateNewChatJob < ApplicationJob
  queue_as :default

  def perform(chat_number, application)
    Chat.create({ number: chat_number, application: application })
  end
end
