ti = require 'timer'
phr = require 'phr'
require 'picolove'
setmetatable(_G, {__index = require('cargo').init('/') })
lm = love.mouse
lg = love.graphics

local function cur()
    circ(cx, cy, 24, {1, 0.5, 0}, 5)
    line(cx-12, cy, cx-36, cy, {1, 0.5, 0}, 5)
    line(cx+12, cy, cx+36, cy, {1, 0.5, 0}, 5)
    line(cx, cy-12, cx, cy-36, {1, 0.5, 0}, 5)
    line(cx, cy+12, cx, cy+36, {1, 0.5, 0}, 5)
end

function love.load()
    ginit()
	mspr = {x = mscrw, y = mscrh*0.8}
	proof = ''
	lvl = 1
	st = 1
	words_active = false
	bullet = {x = scrw * 2, ox = 0, oy = 0}
	cx, cy, t = 0, 0, 0
	words = {}
    kids = {}
    vid = lg.newVideo('assets/vid.ogv')
    vid_options = {r = 0, s = 0}
    for i=1, #phr do
	    add(kids, assets[phr[i][5]])
    end
    lg.setNewFont('neut.ttf', 50)
    load_kid(1)
    done = false
    bgmusic = msc('kazoo.mp3')
    lm.setVisible(false)
end

function love.update(dt)
    ti.update(dt)
    t=t+dt
    if st == 2 then
        foreach(words, update_word)
	end
    cx, cy = lm.getPosition()
end

function love.draw()
    if st == 1 then
        spr(assets.title,0,0)
        cur()
    elseif st == 2 then
        -- draw bg
        spr(assets.room,0,0)
        -- draw main kid
        if not done then
        sprc(kids[lvl], mspr.x + sin(t) * 60, mspr.y + cos(cos(t)/t) * 20, 
            {sx = 3, r = sin(t/2), ox = cos(t/2) * 40, kx = sin(t)/10, kx = sin(t)/10})
        end
            -- draw proof
        pushtransro(30, 400, -rad(20))
            rectf(-10, 10, 170, 54, {0.3, 0.3, 0.3})
            circf(160, 37, 27, {0.3, 0.3, 0.3})
            prt(proof, 0, 0)
        lg.pop()
		-- draw words if active
		if words_active then
			foreach(words, draw_word)
		end
		-- draw cursor
        cur()
		-- draw bullet
        pushtransro(bullet.ox, bullet.oy, rad(-30))
            lg.setColor(0,0,0)
            for i=-1,1 do
                for j=-1,1 do
                    prt(proof, bullet.x + i*3, -strh(proof)/2 + j*3)
                end
            end
            lg.setColor(1,1,1)
			prt(proof, bullet.x, -strh(proof)/2)
        lg.pop()

        if done then
            lg.draw(vid, mscrw, mscrh,
                    vid_options.r, vid_options.s, vid_options.s,
                    vid:getWidth()/2,vid:getHeight()/2)
        end
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
	return {str=str, x=x, y=y, w=w, h=h, cor=correct, dir = -1, spd = rnd(2,4)}
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
    lg.setColor(0,0,0)
    for i=-1,1 do
        for j=-1,1 do
            prtc(w.str, w.x + w.w/2 + i*3, w.y + w.h / 2 + j*3)
        end
    end
    lg.setColor(1,1,1)
    prtc(w.str, w.x + w.w/2, w.y + w.h / 2, {clr = c})
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
    if lvl < #phr then
        lvl=i(lvl)
        load_kid(lvl)
        mspr.x, mspr.y = scrw + 500, mscrh + scrh / 3
        ti.tween(0.2, mspr, {x = mscrw, y = mscrh*0.8}, 'linear')
    else
        words_active = false
        bgmusic:stop()
        done = true
        vid:play()
        vid:pause()
        ti.tween(1, vid_options, {r = 8 * math.pi, s = 1}, 'linear', 
                    function()
                        vid:play()
                    end)
    end
end