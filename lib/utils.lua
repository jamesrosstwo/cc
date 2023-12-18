local utils = {}

function utils.CoordString(px, py, pz)
    return "<x=" .. px .. ", y=" .. py .. ", z=" .. pz .. ">"
end

function utils.Sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

return utils