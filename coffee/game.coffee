# pushTheCode.
# Copyright (C) 2012,  Davide Gessa
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

# Init the engine
pp = PP

pp.init("game", 640, 480)
pp.loop.rate = 32
#touch(pp)

# Load resources
pp.spr.loading = new pp.Sprite('data/loading.png',1,0,0)
pp.spr.welcome = new pp.Sprite('data/welcome.png',1,0,0)
pp.spr.start = new pp.Sprite('data/start.png',1,0,0)
pp.spr.background = new pp.Sprite('data/background.png',1,0,0)
pp.spr.gameover = new pp.Sprite('data/gameover.png',1,0,0)
pp.spr.retry = new pp.Sprite('data/retry.png',1,0,0)

pp.spr.player = {}
pp.spr.player.right = new pp.Sprite('data/pr.png',19,0,0)
pp.spr.player.left = new pp.Sprite('data/pl.png',19,0,0)
pp.spr.player.mask = new pp.Sprite('data/playermask.png',1,0,0)

pp.spr.objects = {}
pp.spr.objects.p10 = new pp.Sprite('data/p10.png',1,0,0)
pp.spr.objects.p20 = new pp.Sprite('data/p20.png',1,0,0)
pp.spr.objects.p50 = new pp.Sprite('data/p50.png',1,0,0)
pp.spr.objects.m5 = new pp.Sprite('data/m5.png',1,0,0)
pp.spr.objects.m10 = new pp.Sprite('data/m10.png',1,0,0)
pp.spr.objects.m20 = new pp.Sprite('data/m20.png',1,0,0)
pp.spr.objects.mask = new pp.Sprite('data/obmask.png',1,0,0)

pp.snd.mhit = new pp.Sound('data/sounds/dong02.ogg')
pp.snd.lastsec = new pp.Sound('data/sounds/dong03.ogg')
pp.snd.end = new pp.Sound('data/sounds/stop01.ogg')
pp.snd.button = new pp.Sound('data/sounds/bass_acid01.ogg')

pp.global.best_score = 0


drawPercentage = =>
    percent = Math.round((pp.load.completed/pp.load.total) * 100)
    pp.draw.rectangle(0, 0, 640, 480, false, '#fff')
    pp.draw.font = 'normal normal normal 25px Georgia'
    pp.draw.color = '#444'
    pp.draw.textHalign = 'center'
    #pp.draw.rectangle(10, 325, percent * 620 / 100 + 10, 328, false, '#333')
    pp.draw.text(320, 240, 'Loading '+percent+'% ...')

loadingBar = window.setInterval(drawPercentage, 50)

# Game function
game = -> 
    window.clearInterval(loadingBar)
    
    # Welcome objects
    pp.obj.start =
        mask: pp.spr.start.mask
        depth: -1    
        
        initialize: (t) =>
            t.x = 520
            t.y = 10
        draw: (t) => 
            pp.spr.start.draw(t.x, t.y)
        tick: (t) =>
            if pp.mouse.left.down and pp.collision.point(t, pp.mouse.x, pp.mouse.y,false)
                pp.snd.button.play()
                pp.loop.room = pp.rm.play

    pp.obj.welcome =
        depth: -1
        draw: (t) => 
            pp.spr.welcome.draw(0,0)     
             
            
    # Play objects  
    pp.obj.background =
        depth: -1
        draw: (t) => 
            pp.spr.background.draw(0,0)  
   
    pp.obj.score =     
        initialize: (t) =>
            t.countdown = new pp.Alarm (-> pp.loop.room = pp.rm.gameover)
            t.countdown.time = pp.loop.rate * 59
				   
        draw: (t) =>                
            pp.draw.textHalign = 'left'
            pp.draw.textValign = 'bottom'
            pp.draw.color = '#999999'
            pp.draw.font = 'normal normal normal 18px Georgia'
            pp.draw.text(20,35,'Lines of code pushed: '+pp.global.score+' (best: '+pp.global.best_score+')')
            
            pp.draw.color = 'red' if (t.countdown.time <= (pp.loop.rate * 5))
			    
            pp.draw.font = 'normal normal normal 16px Georgia'
            pp.draw.text(510,35,Math.ceil(t.countdown.time/pp.loop.rate)+' seconds left')
            
            
    pp.obj.player =
        mask: pp.spr.player.mask.mask
        spritel: pp.spr.player.left
        spriter: pp.spr.player.right
        i: 0
        dir: true
             
        initialize: (t) =>
            t.x = 640/2
            t.y = 410
            
        tick: (t) =>   
            if (pp.key.left.pressed) or (pp.mouse.left.pressed && pp.mouse.x < t.x)
                t.dir = true
                t.x -= 10
                t.x = 5 if (t.x < 5)
                    
                
            if (pp.key.right.pressed) or (pp.mouse.left.pressed && pp.mouse.x > t.x)
                t.dir = false
                t.x += 10
                t.x = 570 if (t.x > 570)

                                    
        draw: (t) =>
            if t.dir
                t.spriter.draw(t.x,t.y,t.i)
            else
                t.spritel.draw(t.x,t.y,t.i)
                
            t.i = (t.i + 1) % 19
            
            
    pp.obj.objects =
        parent:
            mask: pp.spr.objects.mask.mask
            
            initialize: (t) =>
                t.x = 5 + Math.floor(Math.random() * 600)
                t.y = 40
                t.angle = 0

            tick: (t) =>
                t.y += t.vspeed
                
                if t.y > 410
                    p = pp.obj.player
                    
                    # Check if it's colliding with the player
                    if not ((t.x > (p.x + 64)) or ((t.x + 32) < p.x))
                        pp.global.score += t.value
                        pp.loop.remove(t)
                        
                        if t.value < 0
                            pp.snd.mhit.play()
                        #else
                        #    pp.snd.phit.play()
                        
                        pp.global.score = 0 if (pp.global.score < 0)

                
                if t.y > 440
                    if t.value > 0
                        pp.global.score -= Math.floor(t.value / 10)
                    else
                        pp.global.score += Math.floor(Math.abs(t.value) / 10)
                            
                    pp.global.score = 0 if (pp.global.score < 0)
                        
                    pp.loop.remove(t)
                            
				     
            draw: (t) => 
                t.sprite.draw(t.x,t.y)

        p50:
            vspeed: 5
            value: 50
            sprite: pp.spr.objects.p50
        p20:
            vspeed: 4
            value: 20
            sprite: pp.spr.objects.p20            
        p10:
            vspeed: 3
            value: 10
            sprite: pp.spr.objects.p10            
        m20:
            vspeed: 5
            value: -20
            sprite: pp.spr.objects.m20            
        m10:
            vspeed: 4
            value: -10
            sprite: pp.spr.objects.m10            
        m5:
            vspeed: 3
            value: -5
            sprite: pp.spr.objects.m5


    pp.obj.objects.p50.proto = pp.obj.objects.parent
    pp.obj.objects.p20.proto = pp.obj.objects.parent
    pp.obj.objects.p10.proto = pp.obj.objects.parent
    pp.obj.objects.m5.proto = pp.obj.objects.parent
    pp.obj.objects.m20.proto = pp.obj.objects.parent
    pp.obj.objects.m10.proto = pp.obj.objects.parent
   
         
    
    # Gameover objects  
    pp.obj.scoreover =   
        draw: (t) =>
            pp.draw.textHalign = 'left'
            pp.draw.textValign = 'bottom'
            pp.draw.color = '#bbbbbb'
            pp.draw.font = 'normal normal normal 35px Georgia'
            pp.draw.text(80,250,'With '+pp.global.score+' lines of code pushed')
            
            
            #pp.draw.color = '#888888'
            #if best_score == pp.global.score
            #    pp.draw.font = 'normal normal normal 25px Georgia'
            #    pp.draw.text(10,35,'New High Score!')               
            #else
            #    pp.draw.font = 'normal normal normal 25px Georgia'
            #    pp.draw.text(10,35,'The High Score is '+best_score)
                
            

    pp.obj.retry =
        mask: pp.spr.retry.mask
        depth: -1    
        
        initialize: (t) =>
            t.x = 500
            t.y = 10  
        draw: (t) => 
            pp.spr.retry.draw(t.x, t.y)
        tick: (t) =>
            if pp.mouse.left.down and pp.collision.point(t, pp.mouse.x, pp.mouse.y,false)
                pp.snd.button.play()
                pp.loop.room = pp.rm.play

    pp.obj.gameover =
        depth: -1
        draw: (t) => 
            pp.spr.gameover.draw(0,0)      
            
	
	# Welcome gamestate	
    pp.rm.welcome = =>
        pp.loop.register(pp.obj.welcome, 0, 0)
        pp.loop.register(pp.obj.start, 0, 0)


    # Play gamestate
    pp.rm.play = =>
        pp.global.score = 0
        pp.loop.register(pp.obj.background, 0, 0)
        pp.loop.register(pp.obj.score, 0, 0)
        pp.loop.register(pp.obj.player, 0, 0)
        
        creator = new pp.Alarm( -> 
            ob = pp.obj.objects
            pp.loop.beget(Math.choose(ob.p10,ob.m5,ob.p20,ob.m10,ob.p50,ob.m20,ob.p10))
            this.time = pp.loop.rate * 0.5
        )
        creator.time = 0
        
        
    # Gameover gamestate
    pp.rm.gameover = =>
        pp.global.best_score = pp.global.score if (pp.global.score > pp.global.best_score)
            
        pp.snd.end.play()
            
        pp.loop.register(pp.obj.gameover, 0, 0)
        pp.loop.register(pp.obj.scoreover, 0, 0)
        pp.loop.register(pp.obj.retry, 0, 0)
        
    
        
    
    # Set the initial gamestate
    pp.loop.active = true
    pp.loop.room = pp.rm.welcome

pp.load(game)
