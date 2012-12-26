
window.onload = function(){

    var stage = new Kinetic.Stage({
        container: 'title_container',
        width: 578,
        height: 300
    });
    var layer = new Kinetic.Layer();
    var line = new Kinetic.Polygon({
	points: [1, 1, 1, 17, 11, 17, 11, 7, 9, 7, 9, 1, 1, 1],
	strokeWidth: 2,
	stroke: 'cyan'
    });
/*    var rect = new Kinetic.Rect({
        x: 100,
        y: 100,
        width: 100,
        height: 50,
        fill: 'green',
        stroke: 'black',
        strokeWidth: 2,
        opacity: 0.2
    });*/
    layer.add(line);
    stage.add(layer);

    setTimeout(function() {
        line.transitionTo({
//	    points: [10, 10, 10, 170, 110, 170, 110, 70, 90, 70, 90, 10, 10, 10],
	    strokeWidth: 5,
	    duration: 1,
	});
    }, 1000);

/*    setTimeout(function() {
        rect.transitionTo({
            x: 400,
            y: 30,
            rotation: Math.PI * 2,
            opacity: 1,
            strokeWidth: 6,
            scale: {
		x: 1.3,
		y: 1.3
            },
            duration: 1,
        });
    }, 1000);
*/
}
