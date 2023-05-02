require 'ruby2d'

WIDTH = 600
HEIGHT = 800
BASE_COLOR = '#ffffff'
BACKGROUND_COLOR = '#000000'
BOX = 20 

def draw_score(score)
  Text.new(score,x: 10, y: 10, size: 30, color: 'blue')
end

class Snake
  attr_accessor :direction, :score
  attr_reader   :body

  def initialize
    @body      = [[2,2], [2,3], [2,4], [2,5]]
    @direction = 'down'
    @score     = 0
    @grow      = false
  end

  def draw 
    @body.each do |element|
      Square.new(x: element[0] * BOX, y: element[1] * BOX, size: BOX - 1, color: BASE_COLOR)
    end
  end 

  def move
    @body.shift unless @grow
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

    @grow = false
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

  def grow
    @grow = true
  end

  def hit_wall?
    @body.last[0] < 0 || @body.last[0] > (WIDTH / BOX) ||  @body.last[1] < 0 || @body.last[0] > (HEIGHT / BOX) 
  end 

  def hit_itself? 
    @body.uniq.length != @body.length
  end

  private 
  def set_head_image
  end
end

class Fruit
  def initialize(snake_body)
    @x = WIDTH / BOX / 2 
    @y = HEIGHT / BOX / 2 
  end

  def respawn(snake_body)
    loop do
      @x = rand(1...WIDTH / BOX)
      @y = rand(1...HEIGHT / BOX)

      break unless snake_body.any?([@x, @y])
    end 
  end

  def draw 
    Square.new(x: @x * BOX, y: @y * BOX, size: BOX, color: 'red')
  end

  def eaten?(snake_body)
    snake_body.last == [@x, @y]
  end
end

set width: WIDTH
set height: HEIGHT
set color: BACKGROUND_COLOR
set fps_cap: 10

snake = Snake.new
fruit = Fruit.new(snake.body)

update do
  clear 

  snake.draw
  fruit.draw
  draw_score(snake.score)

  if snake.hit_wall? || snake.hit_itself? 
    Text.new("GAME OVER", x: 100, y: 300, size: 70, color: 'red')
    next
  end 

  snake.move

  if fruit.eaten?(snake.body)
    fruit.respawn(snake.body)
    snake.grow

    snake.score += 10
  end
end

on :key_down do |event|
  if ['up','down', 'left', 'right'].any? event.key
    if snake.possible_direction? event.key
      snake.direction = event.key
    end
  end
end

show