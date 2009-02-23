module MagicalSavageBeast
  module Acts
    module MagicalSavageUser
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_magical_savage_user
          self.send :include, MagicalSavageBeast::Acts::MagicalSavageUser::InstanceMethods

          class_eval do
            has_many :moderatorships, :dependent => :destroy
            has_many :forums, :through => :moderatorships, :order => "#{Forum.table_name}.name"
            has_many :posts
            has_many :topics
            has_many :monitorships
            has_many :monitored_topics, :through => :monitorships, :conditions => ["#{Monitorship.table_name}.active = ?", true], :order => "#{Topic.table_name}.replied_at desc", :source => :topic
          end
        end
      end

      module InstanceMethods
        def display_name
          name_to_use = nil

          %w{ username login name }.each do |potential_name|
            break unless name_to_use.blank?

            name_to_use = self.send(potential_name) if self.respond_to?(potential_name) && !self.send(potential_name).blank?
          end

          if name_to_use.blank?
            raise NotImplementedError, "Magical Savage Beast cannot determine a display_name to use, please define a display_name method in your #{self.class.class_name} model returning a string of the #{self.class.class_name}'s name. As an alternative you can define a username, login or name method that will never be blank."
          else
            return name_to_use
          end
        end

        def admin?
          false
        end

        def moderator_of?(forum)
          moderatorships.count(:all, :conditions => ['forum_id = ?', (forum.is_a?(Forum) ? forum.id : forum)]) == 1
        end

        def to_xml(options = {})
          options[:except] ||= []
          super
        end
      end
    end
  end

  module ControllerMethods
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def magical_savage_controller_methods
        self.send :include, MagicalSavageBeast::ControllerMethods::InstanceMethods

        class_eval do
          helper_method :admin?
        end
      end
    end

    module InstanceMethods
      protected
      def update_last_seen_at
        return unless logged_in?

        current_user.last_seen_at = Time.now.utc
        current_user.save
      end

      def admin?
        logged_in? && current_user.admin?
      end
    end
  end
end