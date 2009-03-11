module SessionMatchers
  
  class BeForbidden

    def matches?(actual)
      @actual = actual
      @actual.response_code.should == 403
      true
    end

    def failure_message
      "expected response code to be 403 (Forbidden), but it was #{@actual.response_code}"
    end

    def negative_failure_message
      "expected response code not to be 403 (Forbidden), but it was"
    end
  end

  def be_forbidden
    BeForbidden.new
  end
  
end
