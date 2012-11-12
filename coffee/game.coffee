# Init the engine
pp = PP

pp.init("game", 640, 480)
pp.loop.rate = 30

# Load resources
pp.spr.welcome = new pp.Sprite('data/welcome.png',1,0,0)
pp.spr.start = new pp.Sprite('data/start.png',1,0,0)
pp.spr.background = new pp.Sprite('data/background.png',1,0,0)
pp.spr.gameover = new pp.Sprite('data/gameover.png',1,0,0)
pp.spr.retry = new pp.Sprite('data/retry.png',1,0,0)


pp.spr.player = {}
pp.spr.player.right = new pp.Sprite('data/pr.png',19,0,0)
pp.spr.player.left = new pp.Sprite('data/pl.png',19,0,0)

pp.spr.objects = {}
pp.spr.objects.p10 = new pp.Sprite('data/p10.png',1,0,0)
pp.spr.objects.p20 = new pp.Sprite('data/p20.png',1,0,0)
pp.spr.objects.p50 = new pp.Sprite('data/p50.png',1,0,0)
pp.spr.objects.m5 = new pp.Sprite('data/m5.png',1,0,0)
pp.spr.objects.m10 = new pp.Sprite('data/m10.png',1,0,0)
pp.spr.objects.m20 = new pp.Sprite('data/m20.png',1,0,0)


# Game function
game = -> 
    # Welcome objects
    pp.obj.start =
        mask: pp.spr.start.mask
        depth: -1    
        
        initialize: (t) =>
            t.x = 640/2 - 114/2
            t.y = 300
        draw: (t) => 
            pp.spr.start.draw(t.x, t.y)
        tick: (t) =>
            if pp.mouse.left.down and pp.collision.point(t, pp.mouse.x, pp.mouse.y,false)
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
            t.countdown.time = pp.loop.rate * 20
				   
        draw: (t) =>
            pp.draw.textHalign = 'left'
            pp.draw.textValign = 'bottom'
            pp.draw.color = '#999999'
            pp.draw.font = 'normal normal normal 20px Georgia'
            pp.draw.text(20,35,'Lines of code: '+pp.global.score)
            
            if t.countdown.time <= (pp.loop.rate * 5)
                pp.draw.color = 'red'
			    
            pp.draw.font = 'normal normal normal 16px Georgia'
            pp.draw.text(510,35,Math.ceil(t.countdown.time/pp.loop.rate)+' seconds left')
            
            
    pp.obj.player =
        sprite: pp.spr.player.left
        i: 0
             
        initialize: (t) =>
            t.x = 640/2
            t.y = 480 - 80
            
        tick: (t) =>   
        draw: (t) =>
            t.sprite.draw(t.x,t.y,t.i)
            t.i = (t.i + 1) % 19
            
            
    pp.obj.objects =
        parent:
            mask: pp.spr.objects.p20.mask
            
            initialize: (t) =>
                t.x = 5+Math.floor(Math.random() * 600)
                t.y = 40
                t.angle = 0

            tick: (t) =>
                t.y += t.vspeed
                
                if t.y > 450
                    pp.loop.remove(t)
				     
            draw: (t) => 
                t.sprite.draw(t.x,t.y)

        p50:
            vspeed: 4
            sprite: pp.spr.objects.p50
        p20:
            vspeed: 3
            sprite: pp.spr.objects.p20            
        p10:
            vspeed: 2
            sprite: pp.spr.objects.p10            
        m20:
            vspeed: 4
            sprite: pp.spr.objects.m20            
        m10:
            vspeed: 3
            sprite: pp.spr.objects.m10            
        m5:
            vspeed: 2
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
            pp.draw.font = 'normal normal normal 40px Georgia'
            pp.draw.text(80,250,'With '+pp.global.score+' lines of code pushed')

    pp.obj.retry =
        mask: pp.spr.retry.mask
        depth: -1    
        
        initialize: (t) =>
            t.x = 640/2 - 132/2
            t.y = 300        
        draw: (t) => 
            pp.spr.retry.draw(t.x, t.y)
        tick: (t) =>
            if pp.mouse.left.down and pp.collision.point(t, pp.mouse.x, pp.mouse.y,false)
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
            this.time = pp.loop.rate * 2
        )
        creator.time = 0
        
        
    # Gameover gamestate
    pp.rm.gameover = =>
        pp.loop.register(pp.obj.gameover, 0, 0)
        pp.loop.register(pp.obj.scoreover, 0, 0)
        pp.loop.register(pp.obj.retry, 0, 0)
    
    
    # Set the initial gamestate
    pp.loop.active = true
    pp.loop.room = pp.rm.welcome

pp.load(game)
