ti = require 'timer'
phr = require 'phr'
require 'picolove'
setmetatable(_G, {
  __index = require('cargo').init('/')
})
lm = love.mouse
lg = love.graphics

function love.load()
    ginit()
    bspr = {x = -500, y = -500, r = 0}
	mspr = {x = mscrnh, y = mscrnh, ox = 0, oy = 0}
	proof = ''
	lvl = 1
	st = 1
	words_active = false
	bullet = {x = scrw * 2, ox = 0, oy = 0}
	cx, cy = 0, 0
	words = {}
	kids = {}
	for i=0,14 do
		--add(kids, love.graphics.newQuad(i * 32, 0, a.sheet:getWidth(), a.sheet:getHeight(), 32, 32)
    end
    lg.setNewFont('neut.ttf', 60)
	load_kid(1)
end

function love.update(dt)
    ti.update(dt)
    if st == 2 then
        foreach(words, update_word)
	end
    cx, cy = lm.getPosition()
end

function love.draw()
    if st == 1 then
		prtc('stage 1', mscrw, mscrh)
    elseif st == 2 then
        prtc('stage 2', mscrw, mscrh)
		-- draw bg
		-- draw blast kid
		-- draw main kid
        -- draw proof
        prt(proof, 30, 400, {r = -rad(20)})
		-- draw words if active
		if words_active then
			foreach(words, draw_word)
		end
		-- draw cursor
        --sprc(a.cursor, cx, cy)
            rectc(cx, cy, 128, 128)
		-- draw bullet
		lg.push()
		lg.translate(bullet.ox, bullet.oy)
        lg.rotate(rad(-30))
			prt(proof, bullet.x, -strh(proof)/2)
        lg.pop()
    end
end

function love.mousepressed(x, y, b)
    if st == 1 then
		words_active = true
		st = 2
	elseif st == 2 then
		shoot(x, y)
	end
end

function load_kid(ind)
    local info = phr[ind]
    cor_ind = rndi(1,3)
    proof = cond(info[4] == 'm', 'best boy', 'best girl')
	for i=1,3 do
		words[i] = create_word(info[i], i == cor_ind)
    end
end

function create_word(str, correct)
	local x, y =  mz()*scrw, rnd(.1 * scrh, .7 * scrh)
	local w, h = strw(str), strh(str)
	return {str=str, x=x, y=y, w=w, h=h, cor=correct, dir = mn(), spd = rnd(2,4)}
end

function update_word(w)
	w.x = w.x + w.spd * w.dir
    if w.x < -w.w then 
        w.x = scrw
        w.y = rnd(.1 * scrh, .7 * scrh)
    elseif w.x > scrw then
        w.x = -w.w
        w.y = rnd(.1 * scrh, .7 * scrh)
    end
end

function draw_word(w)
	local c = cond(w.cor, {0,1,1}, {1,1,1})
    prt(w.str, w.x, w.y, {clr = c});
    --rect(w.x, w.y, w.w, w.h, {1, 0, 0})
end

function shoot(x, y)
    bullet.ox, bullet.oy = x, y
    bullet.x = 300
	ti.tween(0.45, bullet, {x = 0}, 'linear', function() 
		bullet.x = scrw * 2
		if words_active and inb(x, y, words[cor_ind]) then
            switch_kids()
		end
	end)
end

function switch_kids()
    lvl=i(lvl)
    if lvl <= #phr then
        load_kid(lvl)
        bspr.x, bspr.y, bspr.r = mscrw, mscrh, 0
        mspr.x, mspr.y = scrw + 500, mscrh + scrh / 3
        ti.tween(0.2, bspr, {x = -500, y = -500, r = 7 * math.pi}, 'linear')
        ti.tween(0.2, mspr, {x = mscrw, y = mscrh}, 'linear')
    else
        words_active = false
    end
end