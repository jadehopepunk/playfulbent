module EmailHandler
  class BaseHandler
    
    def initialize(email)
      raise ArgumentError unless email
      @email = email
    end
    
    def process
      raise NotImplementedError
    end

    def processed
      @processed = true
    end
    
    def processed?
      @processed
    end
    
    def handled
      @handled = true
    end
    
    def handled?
      @handled
    end
     
  end
end