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
            t.countdown = new pp.Alarm (=> pp.loop.room = pp.rm.gameover)
				
            t.countdown.time = pp.loop.rate * 99
				   
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
    
    
    # Gameover objects  
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
    
    
    # Gameover gamestate
    pp.rm.gameover = =>
        pp.loop.register(pp.obj.gameover, 0, 0)
        pp.loop.register(pp.obj.retry, 0, 0)
    
    
    # Set the initial gamestate
    pp.loop.active = true
    pp.loop.room = pp.rm.welcome

pp.load(game)
