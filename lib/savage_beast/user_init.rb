module SavageBeast
  module UserInit
    def self.included(base)
      base.class_eval do
        
      end

      base.extend(ClassMethods)
    end

    module ClassMethods
      #implement in your user model
      def currently_online
        false
      end

      def search(query, options = {})
        with_scope :find => { :conditions => query } do
          options[:page] ||= nil
          paginate options
        end
      end

      def moderator_of?(forum)
        moderatorships.count("#{Moderatorship.table_name}.id", :conditions => ['forum_id = ?', (forum.is_a?(Forum) ? forum.id : forum)]) == 1
      end

      def to_xml(options = {})
        options[:except] ||= []
        options[:except] << :email << :login_key << :login_key_expires_at << :password_hash << :openid_url << :activated << :admin
        super
      end

      def update_posts_count
        self.class.update_posts_count id
      end

      def update_posts_count(id)
        User.update_all ['posts_count = ?', Post.count(:id, :conditions => {:user_id => id})],   ['id = ?', id]
      end
    end
  end
end