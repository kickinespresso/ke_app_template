# KickinEspresso App Template
# www.kickinespresso.com
# contact@kickinespresso.com
# ke_template.rb
#rails new cbreeze -m ke_app_template/ke_template.rb
#rails new test3 -m ke_app_template/ke_template.rb
#http://multithreaded.stitchfix.com/blog/2014/01/06/rails-app-templates/
#bootstrap template?


def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')]
end

insert_into_file 'Rakefile', "\nmodule TempFixForRakeLastComment
  def last_comment
    last_description
  end 
end
Rake::Application.send :include, TempFixForRakeLastComment", after: "require File.expand_path('../config/application', __FILE__)\n"



#temp
#gem 'rake', '< 11.0'
gem 'newrelic_rpm'
gem 'pg'
gem 'rollbar'
gem 'friendly_id', '~> 5.1.0'
gem 'ckeditor'
gem 'therubyracer', platforms: :ruby
gem 'simple_form'
gem 'devise'
gem 'activeadmin','~> 1.0.0.pre2'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'font-awesome-rails'

gem_group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'
  gem 'thin'
  #gem 'capistrano-ssh-doctor', '~> 1.0'
end 

gem_group :development, :test do
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.3.0'
  gem 'rubocop', require: false
  gem 'coveralls', require: false
  gem 'reek', require: false
  #gem 'brakeman', require: false
  #https://github.com/railsbp/rails_best_practices
end

gem_group :test do
  gem 'capybara-webkit', '>= 1.8.0'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'webmock'
end


# config the app to use postgres
gsub_file "Gemfile", /^gem\s+["']sqlite3["'].*$/,''
remove_file 'config/database.yml'
template 'database.erb', 'config/database.yml'

  

#  generate "rspec:install"
generate("rspec:install") #rails generate rspec:install
generate("simple_form:install --bootstrap") #rails generate simple_form:install --bootstrap
generate("active_admin:install User") #active_admin:install User  
#generate("bootstrap:install") #bootstrap generators
generate(:controller, "FrontPage index")

#Add to User.rb
#  scope :recent, -> num_users { where.not(last_sign_in_at: nil).order("last_sign_in_at ASC" ).limit(num_users) }


#Application Mailer
file 'app/mailers/application_mailer.rb', <<-CODE
class ApplicationMailer < ActionMailer::Base

end
CODE
#Contact Mailer
file 'app/mailers/contact_mailer.rb', <<-CODE
class ContactMailer < ApplicationMailer
  def contact_me(msg)
    @msg = msg
    mail(from: @msg.email,
    to: "",
    subject: "New Visitor\'s Email")
  end
end
CODE


#Contact Views model
file 'app/views/contacts/new.html.erb', <<-CODE
TODO: contact_todo
CODE

#Contact Views model
file 'app/views/contact_mailer/contact_me.html.erb', <<-CODE
TODO: contact_todo
CODE

#Contact Views model
file 'app/views/contact_mailer/contact_me.text.erb', <<-CODE
TODO: contact_todo
CODE

#Contact Views model
file 'app/views/layouts/mailer.html.erb', <<-CODE
TODO: contact_todo
CODE

#Contact Views model
file 'app/views/layouts/mailer.text.erb', <<-CODE
TODO: contact_todo
CODE

#Header Views model
file 'app/views/layouts/header.html.erb', <<-CODE
TODO: contact_todo
CODE

#Footer Views model
file 'app/views/layouts/footer.html.erb', <<-CODE
TODO: contact_todo
CODE


inside 'config' do
  #copy_file 'database.yml.example'
end

inside 'config/initializers' do
  copy_file 'setup_mail.rb'
end


inside 'app/views/layouts' do
  copy_file '_analytics.html.erb'
  copy_file '_footer.html.erb'
  copy_file '_header.html.erb'
  copy_file '_seo.html.erb'
  copy_file '_flash.html.erb'
end

inside 'app/controllers' do
  copy_file 'contacts_controller.rb'
end

inside 'app/models' do
  copy_file 'contact.rb'
  copy_file 'user.rb',  :force => true
end
inside 'app/admin' do
  copy_file 'dashboard.rb',  :force => true
  copy_file 'footer.rb',  :force => true
end

open('app/assets/stylesheets/application.css', 'a') { |f|
  f << "@import \"bootstrap-sprockets\";\n"
  f << "@import \"bootstrap\";\n"
  f << "@import \"font-awesome\";\n"
}

File.rename('app/assets/stylesheets/application.css','app/assets/stylesheets/application.scss')

open('app/assets/javascripts/application.js', 'a') { |f|
  f << "//= require bootstrap-sprockets\n"
}
#append_file('app/assets/javascripts/application.js', '//= require bootstrap-sprockets')
append_file('db/seeds.rb',"User.create(email:'admin@example.com', password:'password', password_confirmation: 'password')")
rake("db:create")
rake("db:create", env: 'test')
rake("db:migrate")
rake("db:migrate", env: 'test')

route "root 'front_page#index'"
route "resources :contacts, only: [:new, :create]"
route "match '*path' => redirect('/'),via: :get   unless Rails.env.development?"
after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
  #remove sqlite 
  insert_into_file 'Gemfile', "\nruby '2.2.4'", after: "source 'https://rubygems.org'\n"
end

open('.gitignore', 'a') { |f|
  f << ".idea\n"
}

File.open(".ruby-version", 'w') {|f| f.write("2.2.4") }
