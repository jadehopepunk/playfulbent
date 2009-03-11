class CreateMailingListMessages < ActiveRecord::Migration
  def self.up
    create_table :mailing_list_messages do |t|
      t.column :raw_email, :text
      t.column :subject, :string
      t.column :sender_address, :string
      t.column :sender_id, :integer
      t.column :parent_id, :integer
      t.column :group_id, :integer
      t.column :text_body, :text
      t.column :received_at, :datetime
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :mailing_list_messages
  end
end
