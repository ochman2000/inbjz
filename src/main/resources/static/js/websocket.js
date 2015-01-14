
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
    var actualTable, tableBody, tableHeader, expectedTable;

    actualTable = document.getElementById('actual_table');
    tableHeader = getTableHeader(result.actualHeaders);
    tableBody = getTableBody(result.actual);
    actualTable.appendChild(tableHeader);
    actualTable.appendChild(tableBody);

    expectedTable = document.getElementById('expected_table');
    tableHeader = getTableHeader(result.expectedHeaders);
    tableBody = getTableBody(result.expected);
    expectedTable.appendChild(tableHeader);
    expectedTable.appendChild(tableBody);

    $('#sendQueryBtn').button('reset');
}

function getTableHeader(header) {
    var tableHeader = document.createElement('thead');
    var tableHeaderRow = document.createElement('tr');
    for (x in header) {
        var tableRow = document.createElement('th');
        console.log(header[x]);
        tableRow.className = 'col-md-1';
        tableRow.appendChild(document.createTextNode(header[x]));
        tableHeaderRow.appendChild(tableRow);
    }
    tableHeader.appendChild(tableHeaderRow);
    return tableHeader;
}

function getTableBody(rows) {
    var tableBody = document.createElement('tbody');
    for (m in rows) {
        var tableRow = document.createElement('tr');
        var data = rows[m];
        for (k in data) {
            console.log(data[k]);
            var tableData = document.createElement('td');
            tableData.appendChild(document.createTextNode(data[k]));
            tableRow.appendChild(tableData);
        }
        tableBody.appendChild(tableRow);
    }
    return tableBody;
}

function showGreeting(message) {
    var response = document.getElementById('response');
    var p = document.createElement('p');
    p.style.wordWrap = 'break-word';
    p.appendChild(document.createTextNode(message));
    response.appendChild(p);

    $('#sendQueryBtn').button('reset');
}
