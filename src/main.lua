-- a simple platform game 

dt = 0.0166666666666666666

screen_width = 800
screen_height = 600
player_size = 30

player_x = screen_width/2 - player_size/2
player_y = screen_height/2 - player_size/2 
player_x_speed = 0
player_y_speed = 0
global_x = 400
platforms = {}
total_platforms = 1000
platform_width = 50
platform_offset = 10
current_platform = 1
jump_in_progress = false
jump_max_height = 300
jump_remaining = 0
score = 0
last_scored_tile = 1
death_count = 0

function love.load()
    for i=0, total_platforms do
        platforms[i] = math.random(300,590)
        if i%2==1 and math.random(0,100)>50 then
            platforms[i] = 600
        end
    end
end

function calculate_height()
    local current_highest = 600
    left_side = 0
    right_side = platform_width - platform_offset
    for i=0, 100 do
        local current_height = platforms[(current_platform + i) % total_platforms]
        if current_height < current_highest and
            ((left_side <= player_x and
            right_side >= player_x) or
            (right_side >= player_x + player_size and
            left_side <= player_x + player_size)) then
                current_highest = current_height
        end
        left_side = right_side + 1
        right_side = right_side + platform_width
    end
    if current_highest == 600 then
        return 600 + player_size + 50
    end
    return current_highest
end



function love.update(dt)
    if love.keyboard.isDown("e") then
        if not jump_in_progress then
            jump_in_progress = true
            player_y_speed = -15
            jump_remaining = jump_max_height
        end 
    elseif player_y_speed < 0 then
        player_y_speed = player_y_speed + 4
    end
    if love.keyboard.isDown("d") then
        --player_y = player_y +1
    end
    if love.keyboard.isDown("s") then
        player_x_speed = -4
    elseif love.keyboard.isDown("f") then
        player_x_speed = 4
    else
        player_x_speed = 0
    end
    
    floor_level = calculate_height()

    if player_y_speed > 0 and floor_level > player_y + player_size + 1 then
        player_y_speed = player_y_speed + 1
        jump_in_progress = true
    end
    player_x = player_x + player_x_speed
    new_height = calculate_height()
    if player_y + player_size + 1 > new_height and new_height < floor_level-15 then
        player_x = player_x - player_x_speed
        player_x = player_x + player_x_speed/2
        new_height = calculate_height()
        if new_height < floor_level -15 then
            player_x = player_x - player_x_speed/2
        end
    end 
    
    if player_x > 400 then
        --global_x = player_x - 400
        platform_offset = platform_offset + player_x - 400
        while platform_offset >= platform_width do
                if new_height >= 600 and
                    last_scored_tile < current_platform then
                    score = score + 1
                    last_scored_tile = current_platform
                end
                current_platform = current_platform + 1
                
                platform_offset = platform_offset - platform_width
        end
        player_x = 400
    end
    if player_y == 0 then
        player_y_speed = math.max(1, -player_y_speed)
    end 
    if player_x < 0 then
        player_x = 0
    end
    player_y = math.max(player_y + player_y_speed,0)
    if jump_in_progress then
        jump_remaining = jump_remaining + player_y_speed
    end
    if jump_remaining <= 0 then
        jump_remaining = 0
        player_y_speed = player_y_speed + 1
    end
    if player_y + player_size + 1 >= floor_level then
        player_y = floor_level-player_size -1
        jump_in_progress = false
    end
    if player_y >= 599 then 
        -- 600-player_size-5 then
        death_count = death_count + 1
        if player_x < 390 then
            player_x = player_x + platform_width
        else
            player_x = player_x - platform_width
        end
    end
        
    --while platform_offset >= platform_width do
    --        current_platform = current_platform + 1
    --        platform_offset = platform_offset - platform_width
    --end
end

function love.draw()
    -- Draw the score
    love.graphics.print("DEATHS", 200, 50)
    love.graphics.print(death_count, 200, 100)
    love.graphics.print("SCORE", 300, 50)
    love.graphics.print(score, 300, 100)
    if score >= 10 then
    love.graphics.print("YOU WIN! Please keep playing", 300, 150)
    end
    -- Draw our hero
    love.graphics.setColor(0, 255, 0, 255);
    love.graphics.rectangle('fill', player_x, player_y, 
                                player_size, player_size)
    love.graphics.setColor(255, 255, 255, 255);
    -- Draw the ground
    left_side = 0
    right_side = platform_width - platform_offset
    for i=0, 100 do
        local current_height = platforms[(current_platform + i) % total_platforms]
        local platform_height = screen_height - current_height
        if current_height > 0 then
            love.graphics.rectangle('fill', left_side, current_height,
                            right_side - left_side, platform_height)
        end
        left_side = right_side + 1
        right_side = right_side + platform_width
    end 
end
