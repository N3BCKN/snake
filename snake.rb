require 'ruby2d'

WIDTH = 600
HEIGHT = 800
BASE_COLOR = '#ffffff'
BACKGROUND_COLOR = '#000000'
BOX = 20 


class Snake
  attr_accessor :direction

  def initialize
    @body = [[2,2], [2,3], [2,4], [2,5]]
    @direction = 'down'
  end

  def draw 
    @body.each do |element|
      Square.new(x: element[0] * BOX, y: element[1] * BOX, size: BOX - 1, color: BASE_COLOR)
    end
  end 

  def move
    @body.shift
    head = @body.last 

    case @direction
    when 'up'
      @body << [head[0],head[1] - 1]
    when 'down'
      @body << [head[0],head[1] + 1]
    when 'left'
      @body << [head[0] - 1,head[1]]
    when 'right'
      @body << [head[0] + 1,head[1]]     
    end
  end 

  def possible_direction?(new_direction)
   if (@direction == 'up' && new_direction == 'down') 
    return false
   elsif (@direction == 'down' && new_direction == 'up')  
    return false
   elsif  (@direction == 'left' && new_direction == 'right') 
    return false
   elsif  (@direction == 'right' && new_direction == 'left')  
    return false
   end
    true
  end

  private 
  def set_head_image
  end
end





set width: WIDTH
set height: HEIGHT
set color: BACKGROUND_COLOR
set fps_cap: 20

snake = Snake.new

update do
  clear 
  
  snake.draw
  snake.move
end

on :key_down do |event|
  if ['up','down', 'left', 'right'].any? event.key
    if snake.possible_direction? event.key
      snake.direction = event.key
    end
  end
end

show