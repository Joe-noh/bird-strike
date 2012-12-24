
window.onload = function(){
    var canvas  = document.getElementById("title");
    var context = canvas.getContext("2d");

    var timer;

    var data = [{x:0, y:0},{x:0, y:8},{x:2, y:2},{x:3, y:7},{x:13, y:3}]

    function draw(n){
	var p = data[n];
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
	var p = data.shift();
	context.lineTo(p.x*10, p.y*10);
	context.stroke();

	clearTimeout();
	timer = setTimeout(loop, 500);
    }
    context.beginPath();
    context.moveTo(data[0].x, data[0].y);
    data.shift();

    loop();
}
