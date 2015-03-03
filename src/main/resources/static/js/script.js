// Contains the setInterval() object, which is used to stop the animation.
var timer = new Array(); 
// Invoke the function specified in setInterval() every "delay" milliseconds.
// This value affects animation smoothness.
var delay = 16;
var verticalOffset = 400;
var rect  = new Array();
var h = new Array();

$(document).ready(function(){
	$(".legenda").toggle();
	$("#p01").toggle();
  $("#guzik01").click(function(){
    $(".legenda").fadeToggle(2000);
	$("#p01").slideToggle(2000);
  });
});

$(document).ready(function(){
  initialize();
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

function initialize() {
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

h[0]= 228;// 172
h[1]= 176;// 224;
h[2]= 288;// 112;
h[3]= 200;// 200;
h[4]= 160;// 240;
h[5]= 264;// 136;
h[6]= 96; // 304;
h[7]= 168;// 232;
h[8]= 128;// 272;
h[9]= 152;// 248;
h[10]=304;// 96;
h[11]=136;// 264;
h[12]=120;// 280;
h[13]=120;// 280;
h[14]=80; // 320;
h[15]=160;// 240;
h[16]=192;// 208;
h[17]=88; // 312;
h[18]=240;// 160;
h[19]=72; // 328;
}

function rozwin(i) {
    var obj = rect[i];
    var y = h[i];
    var foo = function() { doAnim01(obj, y, i); }; 
    timer[i] = setInterval(foo, delay);
}

function rozwinWszystkie() {
    for (var i=0; i<20; i++) {
        rozwin(i);
    }
}

function zwin(i) {
    var obj = rect[i];
    var y = h[i];
    var foo = function() { doAnim02(obj, y, i); }; 
    timer[i] = setInterval(foo, delay);
}
function zwinWszystkie() {
    for (var i=0; i<20; i++) {
        zwin(i);
    }
}

function doAnim01(obj, y, i)
{
    var y0 = y;
    var y1 = obj.y.baseVal.value;
    height0 = verticalOffset-y0;
    height1 = obj.height.baseVal.value;
    var step = height0/100.0;
    if (y1>y0)
        obj.y.baseVal.value -= step;
    if (height1<height0)
        obj.height.baseVal.value += step;
    if (height1>=height0) {
        console.log("Słupek: "+ i +" zakończył rozwijanie.");
        obj.y.baseVal.value = y0;
        obj.height.baseVal.value = height0;
        clearInterval(timer[i]);
    }
}

function doAnim02(obj, y, i)
{
    var y0 = verticalOffset;
    var y1 = obj.y.baseVal.value; 
    height0 = 0;
    height1 = obj.height.baseVal.value;
    var step = y1/100;
    if (y1<y0)
        obj.y.baseVal.value += step;
    if (height1>height0)
        obj.height.baseVal.value -= step;
    if (height1<=height0) {
        console.log("Słupek: "+ i +" zakończył zwijanie.");
        obj.y.baseVal.value = y0;
        obj.height.baseVal.value = height0;
        clearInterval(timer[i]);
    }
}