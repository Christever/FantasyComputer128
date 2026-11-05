function BOOT()
   
end

function FAN128()
   

    for i = 0, 15 do
        local x = 20 + (i % 8) * 36
        local y = 40 + math.floor(i / 8) * 60

        rect_fill(x, y, x + 28, y + 40, i)
        print(tostring(i), x, y + 44, 1)
    end
end