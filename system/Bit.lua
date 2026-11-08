-- Operations binaires compatibles Lua standard

local Bit = {}

-- ET logique
function Bit.band(a, b)
    local result = 0
    local power = 1

    for i = 1, 32 do
        local bitA = a % 2
        local bitB = b % 2

        if bitA == 1 and bitB == 1 then
            result = result + power
        end

        a = math.floor(a / 2)
        b = math.floor(b / 2)
        power = power * 2
    end

    return result
end

-- OU logique
function Bit.bor(a, b)
    return a + b - Bit.band(a, b)
end

-- OU exclusif
function Bit.bxor(a, b)
    return Bit.bor(a, b) - Bit.band(a, b)
end

-- Inversion des bits
function Bit.bnot(a)
    return 0xFFFFFFFF - a
end

return Bit
