require 'magical_savage_beast'

ActiveRecord::Base.class_eval do
  include MagicalSavageBeast::Acts::MagicalSavageUser
end

ActionController::Base.class_eval do
  include MagicalSavageBeast::ControllerMethods
end

# TODO: Lets just make restful_authentication a requirement.
# ActionView::Base.send :include, SavageBeast::AuthenticationSystem
# ActionController::Base.send :include, SavageBeast::AuthenticationSystem

# Include your application configuration below
# @WBH@ would be nice for this to not be necessary somehow...
# PASSWORD_SALT = '48e45be7d489cbb0ab582d26e2168621' unless Object.const_defined?(:PASSWORD_SALT)
Module.class_eval do
  def expiring_attr_reader(method_name, value)
    class_eval(<<-EOS, __FILE__, __LINE__)
      def #{method_name}
        class << self; attr_reader :#{method_name}; end
        @#{method_name} = eval(%(#{value}))
      end
    EOS
  end
end

# TODO: make the generator add "map.from_plugin :magical_savage_beast" to the routes
# Define the means by which to add our own routing to Rails' routing
class ActionController::Routing::RouteSet::Mapper
  def from_plugin(name)
    eval File.read(File.join(RAILS_ROOT, "vendor/plugins/#{name}/routes.rb"))
  end
end

#--------------------------------------------------------------------------------
# Uncommenting this section of code allows the plugin to work without the engines plugin 
# installed.  Just need to copy the helpers into the lib directory.
# So why use Engines?  
# It allows controller methods to be overridden
# It gives an easy way to access images
# It allows controller views to be overridden
#--------------------------------------------------------------------------------
# Add our models and controllers to the application
# Stolen from http://weblog.techno-weenie.net/2007/1/24/understanding-the-rails-initialization-process
# You can't use config.load_paths because #set_autoload_paths has already been called in the Rails Initialization process
#models_path = File.join(directory, 'app', 'models')
#$LOAD_PATH << models_path
#Dependencies.load_paths << models_path

#controller_path = File.join(directory, 'app', 'controllers')
#$LOAD_PATH << controller_path
#Dependencies.load_paths << controller_path
#config.controller_paths << controller_path

#view_path = File.join(directory, 'app', 'views')
#if File.exist?(view_path)
# ActionController::Base.view_paths.insert(1, view_path) # push it just underneath the app
#end

# Include helpers
#ActionView::Base.send :include, ForumsHelper
#ActionView::Base.send :include, ApplicationHelper
#--------------------------------------------------------------------------------

%w{ models controllers helpers }.each do |dir|
  path = File.join(directory, 'lib', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete path
end

ActionController::Base.view_paths.insert 1, File.join(directory, 'lib', 'views') # push it just underneath the app

ActionView::Base.send :include, ApplicationHelper
ActionView::Base.send :include, ForumsHelper

begin
  require 'gettext/rails'
  GetText.locale = "nl" # Change this to your preference language
rescue MissingSourceFile, LoadError
  class ActionView::Base
    def _(s)
      s
    end
  end
end