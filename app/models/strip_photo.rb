# == Schema Information
#
# Table name: strip_photos
#
#  id            :integer(4)      not null, primary key
#  strip_show_id :integer(4)
#  image         :text(16777215)
#  position      :integer(4)
#

class StripPhoto < ActiveRecord::Base
  @@store_dir = RAILS_ROOT + "/private/images/strip_photo"
  belongs_to :strip_show
  has_many :strip_photo_views, :dependent => :destroy
  has_many :viewers, :through => :strip_photo_views
  file_column :image, :magick => {:geometry => "600>x1000>", :versions => { :thumb => {:size => "80x80!", :crop => "1:1"} }}, :store_dir => @@store_dir
  validates_presence_of :strip_show
  validates_file_format_of :image, :in => ["image/jpeg"]
  validates_filesize_of :image, :in => 0..2.megabytes
  acts_as_list :scope => :strip_show

  def image_thumb
    uses_public_thumb? ? public_image_thumb : private_image_thumb
  end
  
  def image_thumb_for(viewing_user, format)
    thumb_visible_to?(viewing_user) ? image_thumb : access_denied_thumb_file(format)
  end
  
  def image_for(viewing_user, format)
    visible_to?(viewing_user) ? image : access_denied_file(format)
  end
  
  def image_url
    site_base_url + "/strip_photos/#{id}.jpg"
  end  
  
  def image_thumb_url
    uses_public_thumb? ? public_image_thumb_url : private_image_thumb_url
  end
  
  def image_preview
    return image_dir_name + "/preview/" + image_base_name
  end

  def owned_by(some_user)
    strip_show != nil && strip_show.owned_by(some_user)
  end

  def visible_to?(some_user)
    owned_by(some_user) || position <= strip_show.greatest_position_visible_to(some_user)
  end

  def thumb_visible_to?(some_user)
    owned_by(some_user) || position <= strip_show.greatest_position_visible_to(some_user) + 1
  end

  def preview_visible_to(some_user)
    owned_by(some_user) || position == 1
  end

  def next_photo
    strip_show.strip_photos.at(show_index + 1)
  end

  def self.find_for_position(user, position)
    return Array.new if user == nil
    user.strip_shows.collect {|show| show.photo_at_position(position)}.compact
  end

  def user
    strip_show.nil? ? nil : strip_show.user
  end

  def view(other_user)
    unless other_user.nil? || other_user.new_record? || other_user == user || StripPhotoView.exists_for_photo_and_user(self, other_user)
      visible_before = other_user.greatest_stripshow_position_visible_to(user)

      StripPhotoView.ensure_exists_for(self, other_user)

      visible_after = other_user.greatest_stripshow_position_visible_to(user)
      
      if visible_after > visible_before && visible_after > 2
        next_visible_position = visible_before + 1
        next_visible_photos = StripPhoto.find_for_position(other_user, next_visible_position)

        unless next_visible_photos.empty?
          begin
            StripshowMailer.deliver_viewed(user, other_user, next_visible_photos)
          rescue Net::SMTPSyntaxError
          end
        end
      end
    end
  end

  def has_been_viewed_by(other_user)
    !other_user.nil? && (StripPhotoView.exists_for_photo_and_user(self, other_user) || other_user == self.user)
  end
  
  def registered_viewers_count
    StripPhotoView.count(:conditions => ["strip_photo_id = ?", id])
  end
  
  def publish
    FileUtils.mkpath public_image_thumb_dir
    FileUtils.copy private_image_thumb, public_image_thumb_dir
  end
  
  def owners
    [user]
  end
  
  def url
    "http://#{DEFAULT_HOST}/strip_photos/#{to_param}" unless new_record?
  end
  
  def title
    strip_show.title if strip_show
  end

  def first?
    position == 1
  end

  def last?
    position == StripShow::PHOTOS_IN_SET
  end
  
  def disabled?
    strip_show && strip_show.disabled?
  end

protected

  def uses_public_thumb?
    first? && published?
  end

  def published?
    !strip_show.nil? && strip_show.published?
  end

  def image_dir_name
    File.dirname(image)
  end
  
  def image_base_name
    File.basename(image)
  end

  def private_image_thumb
    image_dir_name + "/thumb/" + image_base_name
  end
  
  def public_image_thumb
    public_image_thumb_dir + image_base_name
  end
  
  def public_image_thumb_dir
    RAILS_ROOT + "/public/system/strip_photo/image/#{self.id}/thumb/"
  end
  
  def public_image_thumb_url
    site_base_url + "/system/strip_photo/image/#{self.id}/thumb/#{image_base_name}"
  end
  
  def private_image_thumb_url
    site_base_url + "/strip_photos/#{id}/show_thumb.jpg"
  end
  
  def site_base_url
    'http://' + DEFAULT_HOST
  end
  
  def valid_user_for_second(user)
    user != nil && user.has_stripshow
  end

  def show_index
    strip_show.strip_photos.index(self)
  end

  def access_denied_file(format)
    RAILS_ROOT + "/public/images/access_denied.jpg"
  end

  def access_denied_thumb_file(format)
    RAILS_ROOT + "/public/images/access_denied_thumb.jpg"
  end
  
end
