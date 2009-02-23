class MagicalSavageBeastGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template File.join('db', 'migrate', "create_savage_tables.rb.erb"), File.join('db','migrate'), { :migration_file_name => "create_savage_tables" }
    end
  end
end
