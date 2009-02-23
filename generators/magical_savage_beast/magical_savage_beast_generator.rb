class MagicalSavageBeastGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Checking for collisions in the controller class names.
      m.class_collisions ForumsController, ModeratorsController, MonitorshipsController, PostsController, TopicsController
      # Checking for collisions in the model class names.
      m.class_collisions Forum, Moderatorship, Monitorship, MonitorshipsSweeper, Post, PostsSweeper, Topic

      # Ensure the necessary directories exist.
      %w{ controllers models helpers }.each do |dir|
        m.directory File.join('app', dir)
      end
      # Create the view directories, if they don't exist.
      %w{ forums layouts monitorships posts topics }.each do |view_dir|
        m.directory File.join('app', 'views', view_dir)
      end

      # Write the controllers to the controller dir.
      %w{ forums_controller.rb moderators_controller.rb monitorships_controller.rb posts_controller.rb topics_controller.rb }.each do |cont|
        m.template File.join('app', 'controllers', "#{cont}.erb"), File.join('app', 'controllers', cont)
      end

      # m.template File.join('app', 'controllers', 'forums_controller.rb.erb'), File.join('app', 'controllers', 'forums_controller.rb')
      # m.template File.join('app', 'controllers', 'moderators_controller.rb.erb'), File.join('app', 'controllers', 'moderators_controller.rb')
      # m.template File.join('app', 'controllers', 'monitorships_controller.rb.erb'), File.join('app', 'controllers', 'monitorships_controller.rb')
      # m.template File.join('app', 'controllers', 'posts_controller.rb.erb'), File.join('app', 'controllers', 'posts_controller.rb')
      # m.template File.join('app', 'controllers', 'topics_controller.rb.erb'), File.join('app', 'controllers', 'topics_controller.rb')

      # Write the models to the model dir.
      %w{ forum.rb moderatorship.rb monitorship.rb monitorship_sweeper.rb post.rb posts_sweeper.rb topic.rb }.each do |mod|
        m.template File.join('app', 'models', "#{mod}.erb"), File.join('app', 'models', mod)
      end

      # m.template File.join('app', 'models', 'forum.rb.erb'), File.join('app', 'models', 'forum.rb')
      # m.template File.join('app', 'models', 'moderatorship.rb.erb'), File.join('app', 'models', 'moderatorship.rb')
      # m.template File.join('app', 'models', 'monitorship.rb.erb'), File.join('app', 'models', 'monitorship.rb')
      # m.template File.join('app', 'models', 'monitorship_sweeper.rb.erb'), File.join('app', 'models', 'monitorship_sweeper.rb')
      # m.template File.join('app', 'models', 'post.rb.erb'), File.join('app', 'models', 'post.rb')
      # m.template File.join('app', 'models', 'posts_sweeper.rb.erb'), File.join('app', 'models', 'posts_sweeper.rb')
      # m.template File.join('app', 'models', 'topic.rb.erb'), File.join('app', 'models', 'topic.rb')

      # Write the forum helper to the helper dir.
      m.template File.join('app', 'helpers', 'forums_helper.rb.erb'), File.join('app', 'helper', 'forums_helper.rb')

      # Write the views to the views dir.
      # Forums
      %w{ _form.html.erb edit.html.erb index.html.erb new.html.erb show.html.erb }.each do |view|
        m.template File.join('app', 'views', 'forums', view), File.join('app', 'views', 'forums', view)
      end
      # Layouts
      %w{ _head.html _post.rss.builder magical_savage_beast.html }.each do |view|
        output_view = view
        if File.extname(view) == '.html'
          output_view = "#{view}.erb"
        end

        m.template File.join('app', 'views', 'layouts', "#{view}.erb"), File.join('app', 'views', 'layouts', output_view)
      end
      # Monitorships
      %w{ create.js.rjs destroy.js.rjs }.each do |view|
        m.template File.join('app', 'views', 'monitorships', "#{view}.erb"), File.join('app', 'views', 'monitorships', view)
      end
      # Posts
      %w{ _edit.html edit.html edit.js.rjs index.html index.rss.builder monitored.html monitored.rss.builder update.js.rjs }.each do |view|
        output_view = view
        if File.extname(view) == '.html'
          output_view = "#{view}.erb"
        end

        m.template File.join('app', 'views', 'posts', "#{view}.erb"), File.join('app', 'views', 'posts', output_view)
      end
      # Topics
      %w{ _form.html edit.html index.html new.html show.html show.rss.builder }.each do |view|
        output_view = view
        if File.extname(view) == '.html'
          output_view = "#{view}.erb"
        end

        m.template File.join('app', 'views', 'topics', "#{view}.erb"), File.join('app', 'views', 'topics', output_view)
      end

      # Create the migration file.
      m.migration_template File.join('db', 'migrate', "create_savage_tables.rb.erb"), File.join('db','migrate'), { :migration_file_name => "create_savage_tables" }
    end
  end
end
