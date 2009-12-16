# remove prototype
FileUtils.rm 'public/javascripts/controls.js'
FileUtils.rm 'public/javascripts/dragdrop.js'
FileUtils.rm 'public/javascripts/effects.js'
FileUtils.rm 'public/javascripts/prototype.js'

# remove standard static cruft
FileUtils.rm 'public/index.html'
FileUtils.rm 'public/images/rails.png'

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

# generate rspec, cucumber
generate :rspec
generate :cucumber

# migrate so rake will run out of the box
rake "db:migrate"
