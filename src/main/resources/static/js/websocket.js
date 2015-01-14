
$(function(){
  $("#includedContent").load("query.html");
});

var stompClient = null;

function connect() {
    var socket = new SockJS('/inbjz');
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame) {
        console.log('Connected: ' + frame);
        subscribeToAll();
    });
}

function greetingsCallBack(greeting) {
    showGreeting(JSON.parse(greeting.body).content);
}

function executeCallBack(statement) {
    alert('Trying to execute: '+statement);
}

function queryCallBack(statement) {
    buildResultTables(JSON.parse(statement.body).content);
}

function subscribeToAll() {
    var sub1 = stompClient.subscribe('/topic/greetings', greetingsCallBack);
    var sub2 = stompClient.subscribe('/topic/execute', executeCallBack);
    var sub3 = stompClient.subscribe('/topic/query', queryCallBack);
}

function disconnect() {
    stompClient.disconnect(function() {
        console.log("Disconnected");
    });
}

function sendQuery() {
    var query = $('#queryTextArea').val();
    stompClient.send("/app/query", {}, JSON.stringify({ 'query': query }));
}

function sendExecuteStmt() {
    var query = $('#queryTextArea').val();
    stompClient.send("/app/execute", {}, JSON.stringify({ 'query': query }));
}

function buildResultTables(result) {
    var response = document.getElementById('response');
    var p = document.createElement('p');
    p.style.wordWrap = 'break-word';
    p.appendChild(document.createTextNode(result));
    response.appendChild(p);

    $('#sendQueryBtn').button('reset');
}

function showGreeting(message) {
    var response = document.getElementById('response');
    var p = document.createElement('p');
    p.style.wordWrap = 'break-word';
    p.appendChild(document.createTextNode(message));
    response.appendChild(p);

    $('#sendQueryBtn').button('reset');
}
