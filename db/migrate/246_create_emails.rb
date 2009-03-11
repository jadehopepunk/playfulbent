class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.text :raw
      t.integer :recipient_id

      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
