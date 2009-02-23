require 'magical_savage_beast'

ActiveRecord::Base.class_eval do
  include MagicalSavageBeast::Acts::MagicalSavageUser
end

# TODO: make the generator add "map.from_plugin :magical_savage_beast" to the routes
# Define the means by which to add our own routing to Rails' routing
class ActionController::Routing::RouteSet::Mapper
  def from_plugin(name)
    eval File.read(File.join(RAILS_ROOT, "vendor/plugins/#{name}/routes.rb"))
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