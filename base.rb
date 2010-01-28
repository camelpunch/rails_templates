# remove prototype
FileUtils.rm 'public/javascripts/controls.js'
FileUtils.rm 'public/javascripts/dragdrop.js'
FileUtils.rm 'public/javascripts/effects.js'
FileUtils.rm 'public/javascripts/prototype.js'

# remove standard static cruft
FileUtils.rm 'public/index.html'
FileUtils.rm 'public/images/rails.png'

# remove 'test' directory as I use specs and cucumber
FileUtils.rm_rf 'test'

# add initializer for activerecord errors without divitis infection
initializer 'custom_activerecord_view_errors.rb', <<-RUBY
module ActionView
  class Base
    @@field_error_proc = Proc.new do |html_tag, instance| 
      if html_tag.include?('class="')
        html_tag.sub(/class="/, 'class="field_with_errors ')
      else
        html_tag.sub(/<(\w*) /, '<\\1 class="field_with_errors" ')
      end
    end
    cattr_accessor :field_error_proc
  end
end
RUBY

# no default route
file 'config/routes.rb', <<-RUBY
ActionController::Routing::Routes.draw do |map|
end
RUBY

# generate rspec, cucumber
generate :rspec
generate :cucumber

# add machinist blueprints file
file 'spec/blueprints.rb', <<-RUBY
require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
end
RUBY

# require blueprints.rb from features/support/extensions.rb
file 'features/support/extensions.rb', <<-RUBY
require 'spec/blueprints'
RUBY

# remove element_locator line from features/support/env.rb
gsub_file 'features/support/env.rb', /require 'cucumber\/webrat\/element_locator'.*/, ''

# migrate so rake will run out of the box
rake "db:migrate"

# git
file '.gitignore', <<-FILE
db/*.sqlite3*
rerun.txt
log
tmp
webrat-*.html
FILE

git :init
git :add => '.'
git :commit => '-a -m "Initial commit"'

