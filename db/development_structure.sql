CREATE TABLE `areas` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `title_dashed` varchar(255) default NULL,
  `anonymous_posts` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `areas_title_dashed_index` (`title_dashed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `avatars` (
  `id` int(11) NOT NULL auto_increment,
  `image` varchar(255) default NULL,
  `profile_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `area_id` int(11) default NULL,
  `title_dashed` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `categories_area_id_index` (`area_id`,`title_dashed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `chapter_preferences` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `story_fragment_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `comment_readings` (
  `id` int(11) NOT NULL auto_increment,
  `comment_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `content` text,
  `conversation_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `conversations` (
  `id` int(11) NOT NULL auto_increment,
  `title_override` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `subject_id` int(11) default NULL,
  `subject_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dare_responses` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `dare_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `description` mediumtext,
  `photo` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dares` (
  `id` int(11) NOT NULL auto_increment,
  `request` mediumtext,
  `requires_photo` tinyint(1) default NULL,
  `requires_description` tinyint(1) default NULL,
  `created_on` datetime default NULL,
  `creator_id` int(11) default NULL,
  `responded_to` tinyint(1) default '0',
  `expired` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `engine_schema_info` (
  `engine_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `gallery_photos` (
  `id` int(11) NOT NULL auto_increment,
  `image` varchar(255) default NULL,
  `profile_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `title` varchar(255) default 'Untitled',
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `genders` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `owner_id` int(11) default NULL,
  `group_name` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `description` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `inspirations` (
  `id` int(11) NOT NULL auto_increment,
  `topic_id` int(11) default NULL,
  `inspiration_id` int(11) default NULL,
  `inspired_id` int(11) default NULL,
  `inspiration_author` varchar(255) default NULL,
  `inspired_author` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `interactions` (
  `id` int(11) NOT NULL auto_increment,
  `actor_id` int(11) default NULL,
  `subject_id` int(11) default NULL,
  `type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `interests` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invitations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `email_address` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `message` mediumtext,
  `strip_show_id` int(11) default NULL,
  `created_on` date default NULL,
  `type` varchar(255) default NULL,
  `recipient_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `kinks` (
  `id` int(11) NOT NULL auto_increment,
  `profile_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mailing_list_messages` (
  `id` int(11) NOT NULL auto_increment,
  `raw_email` text,
  `subject` varchar(255) default NULL,
  `sender_address` varchar(255) default NULL,
  `sender_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `text_body` text,
  `received_at` datetime default NULL,
  `created_at` datetime default NULL,
  `sender_profile_id` int(11) default NULL,
  `message_identifier` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `message_readings` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `message_id` int(11) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `sender_id` int(11) default NULL,
  `recipient_id` int(11) default NULL,
  `subject` varchar(255) default NULL,
  `body` text,
  `created_on` datetime default NULL,
  `parent_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `notification_requests` (
  `id` int(11) NOT NULL auto_increment,
  `email_address` varchar(255) default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL auto_increment,
  `receiver_id` int(11) default NULL,
  `mailer_action` varchar(255) default NULL,
  `content_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `page_version_followers` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `page_version_id` int(11) default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `page_version_readings` (
  `id` int(11) NOT NULL auto_increment,
  `page_version_id` int(11) default NULL,
  `story_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_page_version_readings_on_story_id_and_user_id` (`story_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `page_versions` (
  `id` int(11) NOT NULL auto_increment,
  `text` mediumtext,
  `author_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `story_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `is_end` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `index_page_versions_on_story_id` (`story_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `posts` (
  `id` int(11) NOT NULL auto_increment,
  `category_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `body` mediumtext,
  `body_html` mediumtext,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `type` varchar(255) default NULL,
  `parent_id` int(11) default NULL,
  `area_id` int(11) default NULL,
  `updated_at` datetime default NULL,
  `status` varchar(255) default 'normal',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `profiles` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `created_on` int(11) default NULL,
  `welcome_text` mediumtext NOT NULL,
  `published` tinyint(1) default '0',
  `disabled` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `relationship_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `user_id` int(11) default NULL,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `relationships` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `subject_id` int(11) default NULL,
  `relationship_type_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `description` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `remote_login_sites` (
  `id` int(11) NOT NULL auto_increment,
  `url` varchar(255) default NULL,
  `token` varchar(32) default NULL,
  `area_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sponsorship_payments` (
  `id` int(11) NOT NULL auto_increment,
  `sponsorship_id` int(11) default NULL,
  `amount_cents` int(11) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sponsorships` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `amount_cents` int(11) default NULL,
  `created_at` datetime default NULL,
  `cancelled_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `stories` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `created_on` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `story_fragments` (
  `id` int(11) NOT NULL auto_increment,
  `text` mediumtext,
  `author_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `story_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `story_subscriptions` (
  `id` int(11) NOT NULL auto_increment,
  `story_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `continue_page_i_wrote` tinyint(1) default '1',
  `continue_page_i_follow` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_story_subscriptions_on_story_id_and_user_id` (`story_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `strip_photo_views` (
  `id` int(11) NOT NULL auto_increment,
  `strip_photo_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `strip_photos` (
  `id` int(11) NOT NULL auto_increment,
  `strip_show_id` int(11) default NULL,
  `image` mediumtext,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `strip_shows` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `finished` tinyint(1) default '0',
  `title` varchar(255) default NULL,
  `published_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `syndicated_blog_articles` (
  `id` int(11) NOT NULL auto_increment,
  `title` text,
  `description` text,
  `published_at` datetime default NULL,
  `author` text,
  `link` text,
  `syndicated_blog_id` int(11) default NULL,
  `updated_at` datetime default NULL,
  `content` text,
  `raw_content` text,
  `raw_description` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `syndicated_blogs` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `feed_url` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tag_ranks` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `story_count` int(11) default '0',
  `profile_count` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `story_ratio` int(11) default '0',
  `profile_ratio` int(11) default '0',
  `dare_count` int(11) default '0',
  `dare_ratio` int(11) default '0',
  `blog_article_count` int(11) default '0',
  `blog_article_ratio` int(11) default '0',
  `global_ratio` int(11) default '0',
  `global_count` int(11) default '0',
  PRIMARY KEY  (`id`),
  KEY `index_tag_ranks_on_story_count` (`story_count`),
  KEY `index_tag_ranks_on_profile_count` (`profile_count`),
  KEY `index_tag_ranks_on_dare_count` (`dare_count`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_taggings_on_taggable_type` (`taggable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `nick` varchar(80) default NULL,
  `picture` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `hashed_password` varchar(255) default NULL,
  `created_on` datetime default NULL,
  `gender_id` int(11) default NULL,
  `likes_boys` tinyint(1) default NULL,
  `likes_girls` tinyint(1) default NULL,
  `is_admin` tinyint(1) default '0',
  `permalink` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `yahoo_profiles` (
  `id` int(11) NOT NULL auto_increment,
  `identifier` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `image` varchar(255) default NULL,
  `scraped_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (146)