var canvas = document.getElementById("title");
var context = canvas.getContext("2d");

var point = {x:0, y:20};
var timer;

function draw(x, y){
    context.clearRect(0, 0, 900, 200);
    context.fillRect(x, y, 10, 10);
}

var loop = function(){
    point.x = point.x + 2;
    point.y = point.y + 2;
    draw(point.x, point.y);
    clearTimeout(timer);
    timer = setTimeout(timer, 50);
}
loop();