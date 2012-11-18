function touch(PP) {
    "use strict";
    /*var loffset = function(e) {
        var o = e.offsetLeft;

        if (e.offsetParent !== null) {
            o += loffset(e.offsetParent);
        }
        
        return o;
    };*/
    
    
    var getCoords = function(e) {
        if (e.offsetX) {
            // Works in Chrome / Safari (except on iPad/iPhone)
            return { x: e.offsetX, y: e.offsetY };
        }
        else if (e.layerX) {
            // Works in Firefox
            return { x: e.layerX, y: e.layerY };
        }
        else {
            // Works in Safari on iPad/iPhone
            return { x: e.pageX - cb_canvas.offsetLeft, y: e.pageY - cb_canvas.offsetTop };
        }
    }

    var toffset = function(elem) {
        var o = elem.offsetTop;

        if (elem.offsetParent !== null) {
            o += toffset(elem.offsetParent);
        }
        
        return o;
    };

    PP.touch = {
        /*offsetLeft: loffset(PP.draw.displayCanvas.canvas),
        offsetTop: toffset(PP.draw.displayCanvas.canvas),*/
        /*screenPosition: PP.vector.create(0, 0),*/
        positions: new Array()
    };


    document.addEventListener('touchmove', function(e) {
        var posx = 0,
            posy = 0;

    
        if (!e) {
            e = window.event;
        }
        
        positions = new Array();
        
        if (e.touches) {
            for (var i = 1; i <= e.touches.length; i++) {
                positions[i-1] = getCoords(e.touches[i - 1]);
            }
        }
        else {
            positions[0] = getCoords(e);
        }
        
        alert(positions);
    });
}
