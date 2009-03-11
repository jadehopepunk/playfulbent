class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.column :sender_id, :integer
      t.column :recipient_id, :integer
      t.column :subject, :string
      t.column :body, :text
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :messages
  end
end
