
window.onload = function(){
    var canvas  = document.getElementById("title");
    var context = canvas.getContext("2d");

    var timer;

    var data = [{x:1, y:0},{x:0, y:8},{x:5, y:8}]

    function draw(i){
	var p = data[i];
	context.lineTo(p.x*10, p.y*10);
	context.stroke();
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
	context.beginPath();
	context.moveTo(data[0].x, data[0].y);
	context.moveTo(30, 40);
	context.stroke();
	for(var i=1 ; i < data.size ; i++){
	    draw(i);
	    sleep(1);
	}
    }
    loop();
}
