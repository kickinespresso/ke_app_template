# KickinEspresso App Template
# www.kickinespresso.com
# contact@kickinespresso.com
# ke_template.rb
#rails new cbreeze -m ke_app_template/ke_template.rb

#bootstrap template?
gem 'newrelic_rpm'
gem 'simple_form'
gem 'devise'
gem 'activeadmin','~> 1.0.0.pre1'

gem_group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'
  gem 'thin'
  gem 'capistrano-ssh-doctor', '~> 1.0'
end

gem_group :development, :test do
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.1.0'
end

gem_group :test do
  gem 'capybara-webkit', '>= 1.2.0'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'webmock'
end

gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-bundler'
gem 'capistrano-rbenv'
gem 'capistrano-rails-collection'       #https://github.com/dei79/capistrano-rails-collection
gem 'capistrano-passenger'


#  generate "rspec:install"
generate("rspec:install") #rails generate rspec:install
generate("simple_form:install --bootstrap") #rails generate simple_form:install --bootstrap
generate("active_admin:install User") #active_admin:install User  
generate(:controller, "FrontPage index")


append_file('db/seeds.rb',"User.create(email:'admin@example.com', password:'password', password_confirmation: 'password')")
rake("db:migrate")
#generate(:scaffold, "person name:string")
route "root to: 'FrontPage#index'"

 
after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end