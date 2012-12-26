
window.onload = function(){

    var stage = new Kinetic.Stage({
        container: 'title_container',
        width: 700,
        height: 160
    });
    var layer = new Kinetic.Layer();


    var lines = new Array();
    var a = [[70, 70, 70, 10, 10, 10, 10, 70, 90, 70, 90, 150, 10, 150, 10, 70],
	     [120, 40, 120, 60], [120, 80, 120, 160],
	     [200, 90, 150, 90, 150, 160],
	     [280, 90, 220, 90, 220, 150, 280, 150, 280, 20],
	     [380, 40, 380, 10, 320, 10, 320, 70, 400, 70, 400, 150, 320, 150, 320, 100],
	     [430, 40, 430, 150, 460, 150], [430, 70, 460, 70],
	     [530, 90, 480, 90, 480, 160],
	     [550, 40, 550, 60], [550, 80, 550, 160],
	     [580, 0, 580, 160],
	     [580, 110, 680, 110, 680, 70, 620, 70, 620, 150, 690, 150]];

    var i;
    for(i=0; i<a.length; i++){
	lines[i] = new Kinetic.Line({
	    points: a[i],
	    strokeWidth: 2,
	    stroke: 'cyan'
	});

	layer.add(lines[i]);
	lines[i].transitionTo({
	    strokeWidth: 20,
	    duration: 2,
	    easing: 'ease-in'
	});
    }
    stage.add(layer);

}
