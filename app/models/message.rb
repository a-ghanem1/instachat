require 'elasticsearch/model'

class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat

  def self.search(query, chat_id)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['body']
          }
        },
      }
    )
  end
end
