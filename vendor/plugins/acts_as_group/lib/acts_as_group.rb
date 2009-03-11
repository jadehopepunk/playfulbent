module ActiveRecord
  module Acts #:nodoc:
    module Group #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_group(options = {})
          write_inheritable_attribute(:acts_as_group_options, {
            :taggable_type => ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s,
            :from => options[:from]
          })
          
          class_inheritable_reader :acts_as_group_options

          include ActiveRecord::Acts::Group::InstanceMethods
          extend ActiveRecord::Acts::Group::SingletonMethods          
        end
      end
      
      module SingletonMethods
      end
      
      module InstanceMethods
        
        def fetch_group_data
          unless group_name.blank?
            group_data = GroupData.new
            scraper = Yahoo::Scraper.new(AppConfig.yahoo_scraper_account)
            scraper.populate_group_data(group_name, group_data)
            update_from_group_data(group_data)
          end
        end
      
        protected

          def update_from_group_data(group_data)
            self.attributes = group_data.to_hash
            self.scraped_at = Time.now
          end
      end
    end
  end
end