class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.string :name, unique: true
      t.string :token, unique: true
      t.integer :chats_count, default: 0

      t.timestamps
    end
  end
end
