-- tables
function add(tbl, val)
    table.insert(tbl, val)
end

function del(tbl, ind)
    table.remove(tbl, ind)
end

function delv(tbl, val)
    for k,v in pairs(tbl) do
        if v == val then
            table.remove(tbl, k)
            return
        end
    end
end

function foreach(tbl, fn)
    for _,v in ipairs(tbl) do
        fn(v)
    end
end

-- Funky shorthands
function cond(exp, v1, v2)
    if exp then
        return v1
    end

    return v2
end

function i(val)
    return val + 1
end

function d(val)
    return val - 1
end

function loop(val, lim, dir)
    if dir == 'up' then
        val = mod(val, lim) + 1
    elseif dir == 'down' then
        val = d(val)
        if val <= 0 then val = lim end
    end

    return val
end

function upall(tbl, ...)

end

function drall(tbl)

end

function ginit()
    scrw = love.graphics.getWidth()
    scrh = love.graphics.getHeight()
    mscrw = scrw / 2
    mscrh = scrh / 2
    love.math.setRandomSeed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
end

function quit()
    love.event.quit()
end

function restart()
    love.event.quit('restart')
end

function first(tbl)
    return tbl[1] or nil
end

function sel(tbl, ind)
    return tbl[ind]
end

function rndfrom(tbl)
    return tbl[love.math.random(#tbl)]
end

-- primitive visuals
function _rect(x, y, w, h, opts)
    x, y = cond(opts.center, x - w / 2, x), cond(opts.center, y - h / 2, y)

    local prev_clr = {love.graphics.getColor()}
    local prev_line_wid = love.graphics.getLineWidth()
    if opts.clr then
        love.graphics.setColor(opts.clr)
    end
    if opts.w then
        love.graphics.setLineWidth(opts.w)
    end

    love.graphics.rectangle(opts.mode, x, y, w, h)

    if opts.clr then
        love.graphics.setColor(prev_clr)
    end
    if opts.w then
        love.graphics.setLineWidth(prev_line_wid)
    end
end

function rect(x, y, w, h, ...)
    local opts = { mode = 'line' }
    opts.clr = sel({...},1)
    opts.w = sel({...},2)
    _rect(x, y, w, h, opts)
end

function rectc(x, y, w, h, ...)
    local opts = { mode = 'line', center = true }
    opts.clr = sel({...},1)
    opts.w = sel({...},2)
    _rect(x, y, w, h, opts)
end

function rectf(x, y, w, h, ...)
    local opts = { mode = 'fill' }
    opts.clr = sel({...},1)
    _rect(x, y, w, h, opts)
end

function rectfc(x, y, w, h, ...)
    local opts = { mode = 'fill', center = true }
    opts.clr = sel({...},1)
    _rect(x, y, w, h, opts)
end

function _circ(x, y, r, opts)
    local prev_clr = {love.graphics.getColor()}
    local prev_line_wid = love.graphics.getLineWidth()
    if opts.clr then
        love.graphics.setColor(opts.clr)
    end
    if opts.w then
        love.graphics.setLineWidth(opts.w)
    end

    love.graphics.circle(opts.mode, x, y, r)

    if opts.clr then
        love.graphics.setColor(prev_clr)
    end
    if opts.w then
        love.graphics.setLineWidth(prev_line_wid)
    end
end

function circ(x, y, r, ...)
    local opts = { mode = 'line' }
    opts.clr = sel({...},1)
    opts.w = sel({...},2)
    _circ(x, y, r, opts)
end

function circf(x, y, r, ...)
    local opts = { mode = 'fill' }
    opts.clr = sel({...},1)
    _circ(x, y, r, opts)
end

function line(x1, y1, x2, y2, ...)
    local clr = sel({...},1)
    local w = sel({...},2)

    local prev_clr = {love.graphics.getColor()}
    local prev_line_wid = love.graphics.getLineWidth()
    if clr then
        love.graphics.setColor(clr)
    end
    if w then
        love.graphics.setLineWidth(w)
    end

    love.graphics.line(x1, y1, x2, y2)

    if clr then
        love.graphics.setColor(prev_clr)
    end
    if w then
        love.graphics.setLineWidth(prev_line_wid)
    end
end

-- trig math
function deg(rad)
    return math.deg(rad)
end

function rad(deg)
    return math.rad(deg)
end

function rad2tau(rad)
    return rad / (2 * math.pi)
end

function deg2tau(deg)
    return deg / 360
end

function tau2rad(ang)
    return ang * (2 * math.pi)
end

function tau2deg(ang)
    return ang * 360
end

function sin(tau)
    return math.sin(tau2rad(tau))
end

function cos(tau)
    return math.cos(tau2rad(tau))
end

-- sprite visuals - DONE
function spr(img, x, y, ...)
    local opts = first({...}) or {}
    local r = opts.r or 0
    local sx, sy = opts.sx or 1, opts.sy or opts.sx or 1
    local ox, oy = opts.ox or 0, opts.oy or 0
    local kx, ky = opts.kx or 0, opts.ky or 0

    local prev_clr = {love.graphics.getColor()}
    local new_clr = opts.clr or prev_clr
    love.graphics.setColor(new_clr)
    love.graphics.draw(img, x, y, r, sx, sy, ox, oy, kx, ky)
    love.graphics.setColor(prev_clr)
end

function sprc(img, x, y, ...)
    local opts = first({...}) or {}
    opts.ox, opts.oy = img:getWidth() / 2, img:getHeight() / 2
    spr(img, x, y, opts)
end

function sprsh(img, quad, x, y, ...)
    local opts = first({...}) or {}
    local r = opts.r or 0
    local sx, sy = opts.sx or 1, opts.sy or opts.sx or 1
    local ox, oy = opts.ox or 0, opts.oy or 0
    local kx, ky = opts.kx or 0, opts.ky or 0

    local prev_clr = {love.graphics.getColor()}
    local new_clr = opts.clr or prev_clr
    love.graphics.setColor(new_clr)
    love.graphics.draw(img, quad, x, y, r, sx, sy, ox, oy, kx, ky)
    love.graphics.setColor(prev_clr)
end

function pushtransro(x, y, ...)
    local r = first({...}) or 0
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r)
end

-- string logic - DONE
function strlen(str)
    return string.len(str)
end

function strw(str, font)
    local font = font or love.graphics.getFont()
    return font:getWidth(str)
end

function strh(str, font)
    local font = font or love.graphics.getFont()
    return font:getHeight(str)
end

-- text visuals - DONE
function prt(str, x, y, ...)
    local opts = first({...}) or {}
    local r = opts.r or 0
    local sx, sy = opts.sx or 1, opts.sy or opts.sx or 1
    local ox, oy = opts.ox or 0, opts.oy or 0
    local kx, ky = opts.kx or 0, opts.ky or 0

    local prev_clr = {love.graphics.getColor()}
    local new_clr = opts.clr or prev_clr
    love.graphics.setColor(new_clr)
    love.graphics.print(str, x, y, r, sx, sy, ox, oy, kx, ky)
    love.graphics.setColor(prev_clr)
end

function prtc(str, x, y, ...)
    local opts = first({...}) or {}
    opts.ox, opts.oy = strw(str) / 2, strh(str) / 2
    prt(str, x, y, opts)
end

-- input - DONE
function btn(k)
    return love.keyboard.isDown(k)
end

-- non-trig math - DONE
function abs(num)
    return math.abs(num)
end

function sgn(num)
    if num < 0 then
        return -1
    elseif num > 0 then
        return 1
    end

    return 0
end

function mid(lo, md, hi)
    return math.min(math.max(lo, md), hi)
end

function ismid(lo, md, hi)
    return lo <= md and md <= hi
end

function inb(x, y, b)
    return ismid(b.x, x, b.x+b.w) and ismid(b.y, y, b.y+b.h)
end

function flr(num)
    return math.floor(num)
end

function max(first, second)
    local _sec = second or 0
    return math.max(first, _sec)
end

function min(first, second)
    local _sec = second or 0
    return math.min(first, _sec)
end

function dist(x1, y1, x2, y2)
    return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

function mag(x, y)
    return dist(0, 0, x, y)
end

function mod(a, b)
    return math.fmod(a, b)
end

function norm(x, y)
    local len = mag(x, y)
    return x / len, y / len
end

function indist(x1, y1, x2, y2, d)
    return dist(x1, y1, x2, y2) <= d
end

function aabbcol(b1, b2)
    return b1.x + b1.w > b2.x and b2.x + b2.w > b1.x and b1.y + b1.h > b2.y and b2.y + b2.h > b1.y
end


-- probability
function _rnd(lo, hi)
	return love.math.random()  * (hi - lo) + lo
end

function rnd(...)
    local args = {...}
	if #args == 0 then
		return love.math.random()
	elseif #args == 1 then
		return _rnd(0, args[1])
	elseif #args >= 2 then
		return _rnd(args[1], args[2])
	end
end

function rndi(a, ...)
	local args = {...}
	if #args == 0 then
		return love.math.random(0, a)
	elseif #args == 1 then
		return love.math.random(a, args[1])
	end
end

function mc()
	return rnd() < 0.5
end
function mn()
	return cond(mc(), -1, 1)
end
function mz()
	return cond(mc(), 0, 1)
end

-- Sound
function msc(str)
    local src = love.audio.newSource(str, 'stream')
    src:setLooping(true)
    src:play()

    return src
end