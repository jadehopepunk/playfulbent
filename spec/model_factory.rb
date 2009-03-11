
module ModelFactoryIncluder
  
  def model_factory
    ModelFactory.new
  end

  class ModelFactory
    @@next_int = 0

    def user(options = {})
      create User, options,
        :nick => "Ione Saldana#{next_int}", 
        :email => "ione#{next_int}@tranquility.com", 
        :password => 'secret', 
        :password_confirmation => 'secret'
    end

    def profile(options = {})
      create Profile, options, 
        :user => user
    end
    
    def email(options = {})
      user(:nick => 'jade') unless User.find_by_permalink('jade')
      create Email, options, :raw => load_email(:to_jade)
    end
    
    def fantasy(options = {})
      create Fantasy, options, :creator => user, :description => "I would like to be a teacher and spank a naughty student"
    end
    
    protected
    
      def create(model, options, defaults)
        model.create!(defaults.merge(options))
      end
      
      def load_email(name)
        File.open(RAILS_ROOT + "/spec/fixtures/emails/#{name}.txt").read
      end
      
      def next_int
        @@next_int += 1
      end
  end
    
end

