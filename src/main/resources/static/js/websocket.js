
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
    buildResultTables(JSON.parse(statement.body));
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
    var actualTable = document.getElementById('actual_table');

    var tableHeader = document.createElement('thead');
    var tableHeaderRow = document.createElement('tr');
    var h = result.actualHeaders;
    for (x in h) {
        var tableRow = document.createElement('th');
        console.log(h[x]);
        tableRow.className = 'col-md-1';
        tableRow.appendChild(document.createTextNode(h[x]));
        tableHeaderRow.appendChild(tableRow);
    }
    tableHeader.appendChild(tableHeaderRow);
    actualTable.appendChild(tableHeader);

    var tableBody = document.createElement('tbody');
    h = result.actual;
    for (m in h) {
        var tableRow = document.createElement('tr');
        var l = h[m];
        for (k in l) {
            console.log(l[k]);
            var tableData = document.createElement('td');
            tableData.appendChild(document.createTextNode(l[k]));
            tableRow.appendChild(tableData);
        }
        tableBody.appendChild(tableRow);
    }
    actualTable.appendChild(tableBody);

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
