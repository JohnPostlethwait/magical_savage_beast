require 'magical_savage_beast'

ActiveRecord::Base.class_eval do
  include MagicalSavageBeast::Acts::MagicalSavageUser
end

class << ActionController::Routing::Routes;self;end.class_eval do
  define_method :clear!, lambda {}
end

# ActionController::Routing::RouteSet::Mapper.send :include, MagicalSavageBeast::Routing::MapperExtensions

# TODO: make the generator add "map.from_plugin :magical_savage_beast" to the routes
# Define the means by which to add our own routing to Rails' routing
class ActionController::Routing::RouteSet::Mapper
  def magical_savage_routes
    eval File.read(File.join(RAILS_ROOT, 'vendor', 'plugins', 'magical_savage_beast', 'routes.rb'))
  end
end

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