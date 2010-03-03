# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100303105922) do

  create_table "action_shots", :force => true do |t|
    t.integer "parent_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.integer "review_id"
    t.string  "title"
  end

  add_index "action_shots", ["review_id"], :name => "index_action_shots_on_review_id"

  create_table "activities", :force => true do |t|
    t.string   "type"
    t.integer  "actor_id"
    t.integer  "gallery_photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "review_id"
    t.integer  "strip_show_id"
    t.integer  "dare_id"
    t.integer  "dare_response_id"
    t.integer  "story_id"
    t.integer  "page_version_id"
    t.integer  "profile_id"
  end

  add_index "activities", ["gallery_photo_id"], :name => "index_activities_on_gallery_photo_id"

  create_table "avatars", :force => true do |t|
    t.string  "image"
    t.integer "profile_id"
  end

  add_index "avatars", ["profile_id"], :name => "index_avatars_on_profile_id"

  create_table "base_dare_responses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "dare_id"
    t.datetime "created_on"
    t.text     "description",       :limit => 16777215
    t.string   "photo"
    t.string   "type"
    t.integer  "dare_challenge_id"
  end

  create_table "comment_readings", :force => true do |t|
    t.integer  "comment_id"
    t.integer  "user_id"
    t.datetime "created_on"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
  end

  create_table "conversations", :force => true do |t|
    t.string   "title_override"
    t.datetime "created_at"
    t.integer  "subject_id"
    t.string   "subject_type"
  end

  create_table "crushes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.text     "fantasy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dare_challenges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dare_level",        :default => "flirty"
    t.text     "subject_dare_text"
    t.text     "user_dare_text"
    t.datetime "response_added_at"
    t.datetime "rejected_at"
    t.datetime "completed_at"
  end

  create_table "dare_game_players", :force => true do |t|
    t.integer  "dare_game_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dare_game_players", ["dare_game_id"], :name => "index_dare_game_players_on_dare_game_id"
  add_index "dare_game_players", ["user_id"], :name => "index_dare_game_players_on_user_id"

  create_table "dare_games", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "max_players"
    t.string   "name"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",        :default => "open"
  end

  create_table "dare_rejections", :force => true do |t|
    t.integer  "dare_challenge_id"
    t.integer  "user_id"
    t.text     "rejected_dare_text"
    t.text     "rejection_reason_text"
    t.datetime "created_at"
  end

  create_table "dares", :force => true do |t|
    t.text     "request",              :limit => 16777215
    t.boolean  "requires_photo"
    t.boolean  "requires_description"
    t.datetime "created_on"
    t.integer  "creator_id"
    t.boolean  "responded_to",                             :default => false
    t.boolean  "expired",                                  :default => false
  end

  create_table "db_files", :force => true do |t|
    t.binary "data"
  end

  create_table "email_addresses", :force => true do |t|
    t.string   "address"
    t.datetime "verified_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_addresses", ["user_id"], :name => "index_email_addresses_on_user_id"

  create_table "email_senders", :force => true do |t|
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.text     "raw"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "processed_at"
    t.integer  "email_sender_id"
  end

  create_table "fantasies", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  create_table "fantasy_actors", :force => true do |t|
    t.integer  "user_id"
    t.integer  "fantasy_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fantasy_roles", :force => true do |t|
    t.string   "name"
    t.integer  "fantasy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flickr_accounts", :force => true do |t|
    t.string   "nsid"
    t.string   "token"
    t.string   "username"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flickr_accounts", ["user_id"], :name => "index_flickr_accounts_on_user_id"

  create_table "gallery_photo_files", :force => true do |t|
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "local_gallery_photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gallery_photo_files", ["local_gallery_photo_id"], :name => "index_gallery_photo_files_on_gallery_photo_id"
  add_index "gallery_photo_files", ["parent_id"], :name => "index_gallery_photo_files_on_parent_id"

  create_table "gallery_photos", :force => true do |t|
    t.datetime "created_on"
    t.string   "title",        :default => "Untitled"
    t.integer  "position"
    t.integer  "photo_set_id"
    t.string   "type"
    t.string   "flickr_id"
    t.string   "server"
    t.string   "secret"
    t.integer  "version",      :default => 1
  end

  add_index "gallery_photos", ["photo_set_id"], :name => "index_gallery_photos_on_photo_set_id"

  create_table "genders", :force => true do |t|
    t.string "name"
  end

  create_table "interaction_counts", :force => true do |t|
    t.integer  "actor_id"
    t.integer  "subject_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interactions", :force => true do |t|
    t.integer  "actor_id"
    t.integer  "subject_id"
    t.string   "type"
    t.datetime "created_at"
  end

  add_index "interactions", ["actor_id"], :name => "index_interactions_on_actor_id"
  add_index "interactions", ["subject_id"], :name => "index_interactions_on_subject_id"

  create_table "interests", :force => true do |t|
    t.integer "profile_id"
  end

  add_index "interests", ["profile_id"], :name => "index_interests_on_profile_id"

  create_table "invitations", :force => true do |t|
    t.string  "name"
    t.string  "email_address"
    t.integer "user_id"
    t.text    "message",       :limit => 16777215
    t.integer "strip_show_id"
    t.date    "created_on"
    t.string  "type"
    t.integer "recipient_id"
  end

  create_table "kinks", :force => true do |t|
    t.integer "profile_id"
  end

  add_index "kinks", ["profile_id"], :name => "index_kinks_on_profile_id"

  create_table "locations", :force => true do |t|
    t.string   "country"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logged_db_times", :force => true do |t|
    t.string  "controller_name"
    t.string  "action_name"
    t.integer "visit_count"
    t.float   "average"
    t.float   "min"
    t.float   "max"
    t.float   "standard_deviation"
    t.boolean "is_total",           :default => false
    t.date    "created_on"
  end

  create_table "logged_render_times", :force => true do |t|
    t.string  "controller_name"
    t.string  "action_name"
    t.integer "visit_count"
    t.float   "average"
    t.float   "min"
    t.float   "max"
    t.float   "standard_deviation"
    t.boolean "is_total",           :default => false
    t.date    "created_on"
  end

  create_table "logged_request_times", :force => true do |t|
    t.string  "controller_name"
    t.string  "action_name"
    t.integer "visit_count"
    t.float   "average"
    t.float   "min"
    t.float   "max"
    t.float   "standard_deviation"
    t.boolean "is_total",           :default => false
    t.date    "created_on"
  end

  create_table "message_readings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_on"
    t.integer  "parent_id"
  end

  create_table "notification_requests", :force => true do |t|
    t.string   "email_address"
    t.datetime "created_on"
  end

  create_table "page_version_followers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "page_version_id"
    t.datetime "created_on"
  end

  create_table "page_version_readings", :force => true do |t|
    t.integer  "page_version_id"
    t.integer  "story_id"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "page_version_readings", ["story_id", "user_id"], :name => "index_page_version_readings_on_story_id_and_user_id"

  create_table "page_versions", :force => true do |t|
    t.text     "text",       :limit => 16777215
    t.integer  "author_id"
    t.integer  "parent_id"
    t.integer  "story_id"
    t.datetime "created_on"
    t.boolean  "is_end",                         :default => false
  end

  add_index "page_versions", ["story_id"], :name => "index_page_versions_on_story_id"

  create_table "photo_sets", :force => true do |t|
    t.integer  "profile_id"
    t.string   "title"
    t.integer  "position"
    t.string   "viewable_by"
    t.integer  "minimum_ticks"
    t.boolean  "published",       :default => false
    t.string   "type"
    t.string   "flickr_set_name"
    t.string   "flickr_set_id"
    t.string   "flickr_set_url"
    t.datetime "last_fetched_at"
    t.integer  "version",         :default => 1
  end

  add_index "photo_sets", ["profile_id"], :name => "index_photo_sets_on_profile_id"

  create_table "product_images", :force => true do |t|
    t.string   "original_image_url"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_images", ["parent_id"], :name => "index_product_images_on_parent_id"
  add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"

  create_table "product_urls", :force => true do |t|
    t.string   "original_url"
    t.string   "affiliate_url"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_urls", ["product_id"], :name => "index_product_urls_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "products", ["type"], :name => "index_products_on_type"

  create_table "profiles", :force => true do |t|
    t.integer "user_id"
    t.integer "created_on"
    t.text    "welcome_text", :limit => 16777215
    t.boolean "published",                        :default => false
    t.boolean "disabled",                         :default => false
    t.integer "location_id"
  end

  create_table "relationship_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.integer  "user_id"
    t.integer  "position"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.integer  "relationship_type_id"
    t.datetime "created_at"
    t.text     "description"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sexyness_rating"
    t.integer  "durability_rating"
    t.integer  "cleaning_rating"
    t.integer  "pleasure_rating"
    t.integer  "overall_rating"
    t.text     "body"
  end

  add_index "reviews", ["created_at"], :name => "index_reviews_on_created_at"
  add_index "reviews", ["product_id"], :name => "index_reviews_on_product_id"
  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sponsorship_payments", :force => true do |t|
    t.integer  "sponsorship_id"
    t.integer  "amount_cents"
    t.datetime "created_at"
  end

  create_table "sponsorships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "amount_cents"
    t.datetime "created_at"
    t.datetime "cancelled_at"
  end

  add_index "sponsorships", ["user_id"], :name => "index_sponsorships_on_user_id"

  create_table "stories", :force => true do |t|
    t.string   "title"
    t.datetime "created_on"
    t.datetime "updated_at"
  end

  create_table "story_subscriptions", :force => true do |t|
    t.integer "story_id"
    t.integer "user_id"
    t.boolean "continue_page_i_wrote",  :default => true
    t.boolean "continue_page_i_follow", :default => false
  end

  add_index "story_subscriptions", ["story_id", "user_id"], :name => "index_story_subscriptions_on_story_id_and_user_id", :unique => true

  create_table "strip_photo_views", :force => true do |t|
    t.integer "strip_photo_id"
    t.integer "user_id"
  end

  create_table "strip_photos", :force => true do |t|
    t.integer "strip_show_id"
    t.text    "image",         :limit => 16777215
    t.integer "position"
  end

  create_table "strip_show_views", :force => true do |t|
    t.integer  "strip_show_id"
    t.integer  "user_id"
    t.integer  "max_position_viewed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "strip_shows", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "finished",     :default => false
    t.string   "title"
    t.datetime "published_at"
  end

  create_table "syndicated_blog_articles", :force => true do |t|
    t.text     "title"
    t.text     "description"
    t.datetime "published_at"
    t.text     "author"
    t.text     "link"
    t.integer  "syndicated_blog_id"
    t.datetime "updated_at"
    t.text     "content"
    t.text     "raw_content"
    t.text     "raw_description"
  end

  create_table "syndicated_blogs", :force => true do |t|
    t.string  "title"
    t.string  "feed_url"
    t.integer "user_id"
  end

  create_table "tag_ranks", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "story_count",         :default => 0
    t.integer  "profile_count",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "story_ratio",         :default => 0
    t.integer  "profile_ratio",       :default => 0
    t.integer  "dare_count",          :default => 0
    t.integer  "dare_ratio",          :default => 0
    t.integer  "blog_article_count",  :default => 0
    t.integer  "blog_article_ratio",  :default => 0
    t.integer  "global_ratio",        :default => 0
    t.integer  "global_count",        :default => 0
    t.integer  "gallery_photo_count"
    t.integer  "gallery_photo_ratio"
    t.integer  "review_count",        :default => 0
    t.integer  "review_ratio",        :default => 0
  end

  add_index "tag_ranks", ["dare_count"], :name => "index_tag_ranks_on_dare_count"
  add_index "tag_ranks", ["gallery_photo_count"], :name => "index_tag_ranks_on_gallery_photo_count"
  add_index "tag_ranks", ["profile_count"], :name => "index_tag_ranks_on_profile_count"
  add_index "tag_ranks", ["story_count"], :name => "index_tag_ranks_on_story_count"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["taggable_type"], :name => "index_taggings_on_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "users", :force => true do |t|
    t.string   "nick",                     :limit => 80
    t.string   "picture"
    t.string   "hashed_password"
    t.datetime "created_on"
    t.integer  "gender_id"
    t.boolean  "likes_boys"
    t.boolean  "likes_girls"
    t.boolean  "is_admin",                               :default => false
    t.string   "permalink"
    t.datetime "updated_at"
    t.datetime "last_logged_in_at"
    t.boolean  "is_review_manager",                      :default => false
    t.integer  "primary_email_address_id"
  end

end
