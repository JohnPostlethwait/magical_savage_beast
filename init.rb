require 'magical_savage_beast'

ActiveRecord::Base.class_eval do
  include MagicalSavageBeast::Acts::MagicalSavageUser
end

ActionController::Base.class_eval do
  include MagicalSavageBeast::ControllerMethods
end

# TODO: make the generator add "map.from_plugin :magical_savage_beast" to the routes
# Define the means by which to add our own routing to Rails' routing
class ActionController::Routing::RouteSet::Mapper
  def from_plugin(name)
    eval File.read(File.join(RAILS_ROOT, "vendor/plugins/#{name}/routes.rb"))
  end
end

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