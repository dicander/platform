-- a simple platform game 

dt = 0.0166666666666666666

screen_width = 800
screen_height = 600
player_size = 30

player_x = screen_width/2 - player_size/2
player_y = screen_height/2 - player_size/2 
player_x_speed = 0
player_y_speed = 0
platforms = {}
total_platforms = 1000
platform_width = 50
platform_offset = 10
current_platform = 1

function love.load()
    for i=0, total_platforms do
        platforms[i] = math.random(300,590)
    end
end

function love.update(dt)
    if love.keyboard.isDown("e") then
        player_y = player_y-1   
    end
    if love.keyboard.isDown("d") then
        player_y = player_y+1
    end
    if love.keyboard.isDown("f") then
        platform_offset = platform_offset + 1
        while platform_offset >= platform_width do
            current_platform = current_platform + 1
            platform_offset = platform_offset - platform_width
        end
    end
        
    player_x = player_x + player_x_speed
    player_y = player_y + player_y_speed
end

function love.draw()
    -- Draw our hero
    love.graphics.rectangle('fill', player_x, player_y, 
                                player_size, player_size)
    -- Draw the ground
    left_side = 0
    right_side = platform_width - platform_offset
    for i=0, 100 do
        local current_height = platforms[(current_platform + i) % total_platforms]
        local platform_height = screen_height - current_height
        love.graphics.rectangle('fill', left_side, current_height,
                            right_side - left_side, platform_height)
        left_side = right_side + 1
        right_side = right_side + platform_width
    end
    
    
end
