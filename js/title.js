
window.onload = function(){
    var canvas  = document.getElementById("title");
    var context = canvas.getContext("2d");

    var timer;

    var data = [{x:0, y:0},{x:0, y:8},{x:5, y:8}]

    function draw(i){
	var p = data[ i ];
	var q = data[i+1];
	context.lineTo(q.x-p.x, q.y-p.y);
    }

    function sleep(time) {
	var d1 = new Date().getTime();
	var d2 = new Date().getTime();
	while (d2 < d1 + time) {
	    d2 = new Date().getTime();
	}
	return;
    }

    var loop = function(){
	for(var i=0 ; i < data.size ; i++){
	    draw(i);
	    sleep(0.5);
	}
    }
    loop();
}
