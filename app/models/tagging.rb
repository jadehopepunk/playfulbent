# == Schema Information
# Schema version: 258
#
# Table name: taggings
#
#  id            :integer(11)   not null, primary key
#  tag_id        :integer(11)   
#  taggable_id   :integer(11)   
#  taggable_type :string(255)   
#  created_at    :datetime      
#

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  belongs_to :story, :class_name => 'Story', :foreign_key => :taggable_id
  belongs_to :profile, :class_name => 'Profile', :foreign_key => :taggable_id
  belongs_to :dare, :class_name => 'Dare', :foreign_key => :taggable_id  
  belongs_to :gallery_photo, :class_name => 'GalleryPhoto', :foreign_key => :taggable_id

  def self.tagged_class(taggable)
    ActiveRecord::Base.send(:class_name_of_active_record_descendant, taggable.class).to_s
  end
  
  def self.find_taggable(tagged_class, tagged_id)
    tagged_class.constantize.find(tagged_id)
  end
  
end
