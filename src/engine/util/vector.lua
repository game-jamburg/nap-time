function assert_vector(v)
    assert(v ~= nil and v:isInstanceOf(Vector))
end

Vector = class("Vector")

function Vector:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Vector:clone()
    return Vector:new(self.x, self.y)
end

function Vector:unpack()
	return self.x, self.y
end

function Vector:__tostring()
	return "[" .. tonumber(self.x) .. ", " .. tonumber(self.y) .. "]"
end

function Vector.__unm(a)
	return Vector:new(-a.x, -a.y)
end

function Vector.__add(a, b)
    assert_vector(a)
    assert_vector(b)
	return Vector:new(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
    assert_vector(a)
    assert_vector(b)
	return Vector:new(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a, b)
	if type(a) == "number" then
		return Vector:new(a*b.x, a*b.y)
	elseif type(b) == "number" then
		return Vector:new(b*a.x, b*a.y)
	else
        assert_vector(a)
        assert_vector(b)
		return a.x*b.x + a.y*b.y
	end
end

function Vector.__concat(a, b)
    return tostring(a) .. tostring(b)
end

function Vector.__div(a, b)
    assert_vector(a)
    assert(type(b) == "number" or b:isInstanceOf(Vector), "Not a number or vector: " .. b)
    if type(b) == "number" then
        return Vector:new(a.x / b, a.y / b)
    else
        return Vector:new(a.x / b.x, a.y / b.y)
    end
end

function Vector.__eq(a, b)
    assert_vector(a)
    assert_vector(b)
	return a.x == b.x and a.y == b.y
end

function Vector.__lt(a,b)
    assert_vector(a)
    assert_vector(b)
	return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function Vector.__le(a,b)
    assert_vector(a)
    assert_vector(b)
	return a.x <= b.x and a.y <= b.y
end

function Vector.permul(a,b)
    assert_vector(a)
    assert_vector(b)
	return Vector:new(a.x*b.x, a.y*b.y)
end

function Vector.perdiv(a,b)
    assert_vector(a)
    assert_vector(b)
    return Vector:new(a.x/b.x, a.y/b.y)
end


function Vector:len2()
	return self.x * self.x + self.y * self.y
end

function Vector:len()
	return math.sqrt(self:len2())
end

function Vector.dist(a, b)
    assert_vector(a)
    assert_vector(b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

function Vector:normalize()
	local l = self:len()
	if l > 0 then
		self.x, self.y = self.x / l, self.y / l
	end
	return self
end

function Vector:normalized()
	return self:clone():normalize()
end

function Vector:rotate(phi)
	local c, s = math.cos(phi), math.sin(phi)
	self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
	return self
end

function Vector:rotated(phi)
	local c, s = math.cos(phi), math.sin(phi)
	return Vector:new(c * self.x - s * self.y, s * self.x + c * self.y)
end

function Vector:angle()
    return self:signedAngleTo(Vector:new(1, 0))
end

function Vector:signedAngleTo(v2)
    return -math.atan2(self.x * v2.y - self.y * v2.x, self * v2)
end

function Vector:angleTo(v2)
    local quotient = (self:len() * v2:len())
    if quotient ~= 0 then
        local input = (self * v2) / quotient
        return math.acos(input)
    else
        return 0
    end
end

function Vector:perpendicular()
	return Vector:new(-self.y, self.x)
end

function Vector:projectOn(v)
    assert_vector(v)
	-- (self * v) * v / v:len2()
	local s = (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return Vector:new(s * v.x, s * v.y)
end

function Vector:mirrorOn(v)
    assert_vector(v)
	local s = 2 * (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return Vector:new(s * v.x - self.x, s * v.y - self.y)
end

function Vector:cross(v)
    assert_vector(v)
	return self.x * v.y - self.y * v.x
end

function Vector:unpack()
    return self.x, self.y
end

function Vector:serialize()
    return string.format('Vector:new(%g, %g)', self.x, self.y)
end

Vector.static.WindowSize = Vector:new(800, 600)