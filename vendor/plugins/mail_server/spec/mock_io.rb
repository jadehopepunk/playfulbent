
class MockIO
  attr_accessor :buffer, :input, :buffer_from
  
  def initialize
    self.buffer = []
    self.input = []
    @reverse_input = []
    @input_position = 0
    @buffer_from = 0
  end
  
  def print(string)
    self.buffer << string
  end
  
  def buffer_from(index)
    buffer[index, buffer.length - index]
  end
  
  def input=(value)
    @input = value
    @reverse_input = input.reverse
  end
  
  def mock_select
    !@reverse_input.empty?
  end
  
  def readpartial(maxlen)
    "#{@reverse_input.pop}\r\n"
  end
  
  def closed?
    !mock_select
  end
  
  def close
  end
    
end