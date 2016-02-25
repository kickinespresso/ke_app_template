# KickinEspresso App Template
# www.kickinespresso.com
# contact@kickinespresso.com
# ke_template.rb
#rails new cbreeze -m ke_app_template/ke_template.rb

#bootstrap template?
gem 'newrelic_rpm'

gem 'pg'
gem 'rollbar', '~> 2.4.0'
gem 'friendly_id', '~> 5.1.0'
gem 'ckeditor'
gem 'therubyracer', platforms: :ruby
gem 'simple_form'
gem 'devise'
gem 'activeadmin','~> 1.0.0.pre2'

gem 'bootstrap-sass', '~> 3.3.4'
gem 'font-awesome-rails'

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
  gem 'rubocop', require: false
  gem 'coveralls', require: false
  gem 'reek', require: false
  #https://github.com/railsbp/rails_best_practices
end

gem_group :test do
  gem 'capybara-webkit', '>= 1.2.0'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'webmock'
end


#  generate "rspec:install"
generate("rspec:install") #rails generate rspec:install
generate("simple_form:install --bootstrap") #rails generate simple_form:install --bootstrap
generate("active_admin:install User") #active_admin:install User  
#generate("bootstrap:install") #bootstrap generators
generate(:controller, "FrontPage index")

file 'app/views/layouts/_seo.html.erb', <<-CODE
  class Foo
  end
CODE
file 'app/views/layouts/_analytics.html.erb', <<-CODE
  class Foo
  end
CODE

#Add to User.rb
#  scope :recent, -> num_users { where.not(last_sign_in_at: nil).order("last_sign_in_at ASC" ).limit(num_users) }


#Add _analytics.html.erb
#Add _seo.html.erb

#admin/dashboard.rb
file 'app/admin/dashboard.rb', <<-CODE
ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_support" do
      span :class => "blank_slate" do
        span 'Need Support? Email us at:'
        span mail_to 'support@kickinespresso.zendesk.com'
      end
    end


    columns do
      column do
        panel "Recent User Logins" do
          table_for User.recent(5) do
            column("Email") {|user| link_to(user.email, admin_user_path(user))}
            column("Signed In at") {|user| user.last_sign_in_at.strftime("%A, %d %b %Y %l:%M %p")    }
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end
  end # content
end
CODE
#admin/footer.rb
file 'app/admin/footer.rb', <<-CODE
module ActiveAdmin
  module Views
    class Footer < Component

      def build
        super :id => "footer"
        super :style => "text-align: left;"

        div do
          link_to "KickinEspresso #{Date.today.year}", 'http://www.kickinespresso.com'
        end
      end

    end
  end
end
CODE

#Contacts
file 'app/controllers/contacts_controller.rb', <<-CODE
class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      ContactMailer.contact_me(@contact).deliver_now
      redirect_to new_contact_path, notice: "Thank you for your message."
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end
end
CODE

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
#Contact Model
file 'app/models/contact.rb', <<-CODE
class Contact
  include ActiveModel::Model
  attr_accessor :name, :email, :content
  validates :name, :email, :content, presence: true
end
CODE

#Flash View
file 'app/views/layouts/_flash.html.erb', <<-CODE
<% if flash[:notice] %>
  <div class="alert alert-success">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= flash[:notice] %>
  </div>

<% elsif flash[:info] %>
  <div class="alert alert-info">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= flash[:info] %>
  </div>

<% elsif flash[:error] %>
  <div class="alert alert-danger">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= flash[:error] %>
  </div>

<% elsif flash[:alert] %>
  <div class="alert alert-warning">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <%= flash[:alert] %>
  </div>  
<% end %>
CODE

#user model
file 'app/models/user.rb', <<-CODE
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  scope :recent, -> num_users { where.not(last_sign_in_at: nil).order("last_sign_in_at ASC" ).limit(num_users) }
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

#Mail Init
file 'config/initializers/setup_mail.rb', <<-CODE
if Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address:        'smtp.mandrillapp.com',
    port:           '587',
    authentication: :plain,
    user_name:      Rails.application.secrets.mandrill_username,
    password:       Rails.application.secrets.mandrill_password,
    domain:         'heroku.com',
    enable_starttls_auto: true
  }
end
CODE






#run('mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss')
#run('touch app/assets/stylesheets/application.scss')

open('app/assets/stylesheets/application.css', 'a') { |f|
  f << "@import \"bootstrap-sprockets\";\n"
  f << "@import \"bootstrap\";\n"
  f << "@import \"font-awesome\";\n"
}
#append_file('app/assets/stylesheets/application.css', '@import "bootstrap-sprockets";')
#append_file('app/assets/stylesheets/application.css', '@import "bootstrap";')
#append_file('app/assets/stylesheets/application.css', '@import "font-awesome";')
File.rename('app/assets/stylesheets/application.css','app/assets/stylesheets/application.scss')

open('app/assets/javascripts/application.js', 'a') { |f|
  f << "//= require bootstrap-sprockets\n"
}
#append_file('app/assets/javascripts/application.js', '//= require bootstrap-sprockets')
#append_file('db/seeds.rb',"User.create(email:'admin@example.com', password:'password', password_confirmation: 'password')")
rake("db:migrate")
route "root 'front_page#index'"
route "match '*path' => redirect('/'),via: :get   unless Rails.env.development?"
route "resources :contacts, only: [:new, :create]"

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

append_file('.gitignore', '.idea')
#append_file('.ruby-version','2.2.0')
File.open(".ruby-version", 'w') {|f| f.write("2.2.0") }
