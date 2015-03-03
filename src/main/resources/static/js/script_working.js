// Contains the setInterval() object, which is used to stop the animation.
var timer; 
// Invoke the function specified in setInterval() every "delay" milliseconds.
// This value affects animation smoothness.
var delay = 8;
var verticalOffset = 400;
var rect  = new Array();
rect[0] = document.getElementById("rec1");
rect[1] = document.getElementById("rec2");
rect[2] = document.getElementById("rec3");
rect[3] = document.getElementById("rec4");
rect[4] = document.getElementById("rec5");
rect[5] = document.getElementById("rec6");
rect[6] = document.getElementById("rec7");
rect[7] = document.getElementById("rec8");
rect[8] = document.getElementById("rec9");
rect[9] = document.getElementById("rec10");
rect[10] = document.getElementById("rec11");
rect[11] = document.getElementById("rec12");
rect[12] = document.getElementById("rec13");
rect[13] = document.getElementById("rec14");
rect[14] = document.getElementById("rec15");
rect[15] = document.getElementById("rec16");
rect[16] = document.getElementById("rec17");
rect[17] = document.getElementById("rec18");
rect[18] = document.getElementById("rec19");
rect[19] = document.getElementById("rec20");

var h = new Array();
h[0]= 172;
h[1]= 224;
h[2]= 112;
h[3]= 200;
h[4]= 240;
h[5]=136;
h[6]=304;
h[7]=232;
h[8]=272;
h[9]=248;
h[10]=96;
h[11]=264;
h[12]=280;
h[13]=280;
h[14]=320;
h[15]=240;
h[16]=208;
h[17]=312;
h[18]=160;
h[19]=328;

$(document).ready(function(){
	$(".legenda").toggle();
	$("#p01").toggle();
  $("#guzik01").click(function(){
    $(".legenda").fadeToggle(2000);
	$("#p01").slideToggle(2000);
  });
});

$(document).ready(function(){
  rozwin();
  $("#guzik02").click(function(){
      rozwin();
  });
});

$(document).ready(function(){
  $("#guzik03").click(function(){
      zwin();
  });
});

function rozwin() {
    timer = setInterval(doAnim01, delay);
}
function zwin() {
    timer = setInterval(doAnim02, delay);
}

function doAnim01()
{
    var obj = document.getElementById("rec3");
    var y = obj.y.baseVal.value;
    height = obj.height.baseVal.value;
    if (y>288)
        obj.y.baseVal.value -= 1;
    if (height<112)
        obj.height.baseVal.value += 1;
    if (height>=112)
        clearInterval(timer);
}

function doAnim02()
{
    var obj = document.getElementById("rec3");
    var y = obj.y.baseVal.value; 
    height = obj.height.baseVal.value;
    if (y<400)
        obj.y.baseVal.value += 1;
    if (height>0)
        obj.height.baseVal.value -= 1;
    if (height<=0)
        clearInterval(timer);
}

/*
$(document).ready(function(){
  rozwinWszystkie();
  $("#guzik02").click(function(){
      rozwinWszystkie();
  });
});

$(document).ready(function(){
  $("#guzik03").click(function(){
      zwinWszystkie();
  });
});

function rozwinWszystkie() {
  for (var i=0; i<20; i++) {
      
        rozwin(rect[i], h[i]);
    }
}
function zwinWszystkie() {
    for (var i=0; i<20; i++) {
        zwin(rect[i], h[i]);
    }
}

function rozwin(obj, y) {
    timer = setInterval(doAnim01(obj, y), delay);
}
function zwin(obj, y) {
    timer = setInterval(doAnim02(obj, y), delay);
}

function doAnim01(obj, y)
{
    var y0 = y;
    var y1 = obj.y.baseVal.value; 
    height0 = verticalOffset-y0;
    height1 = obj.height.baseVal.value;
    if (y1>y0)
        obj.y.baseVal.value -= 1;
    if (height1<height0)
        obj.height.baseVal.value += 1;
    if (height1>=height0)
        clearInterval(timer);
}

function doAnim02(obj, y)
{
    var y0 = y;
    var y1 = obj.y.baseVal.value; 
    height0 = verticalOffset-y0;
    height1 = obj.height.baseVal.value;
    if (y1<y0)
        obj.y.baseVal.value += 1;
    if (height1>height0)
        obj.height.baseVal.value -= 1;
    if (height1<=height0)
        clearInterval(timer);
}
*/