
$(function(){
  $("#includedContent").load("adm/query.html");
});

function connect() {
    var socket = new SockJS('/inbjz');
    stompClient = Stomp.over(socket);
    var headers = {
          login: 'mylogin',
          passcode: 'mypasscode',
          // additional header
          'client-id': '123456'
        };
    stompClient.connect(headers, function(frame) {
        console.log('Connected: ' + frame);
        stompClient.subscribe('/user/queue/position-updates', queryCallBack);
    });
}

function sendQuery() {
    var query = $('#queryTextArea').val();
    var taskId = $('#taskId').text();
    var mode = $('#option2').is(':checked');
    if (mode) {
        mode = 'real';
    } else {
        mode = 'protected';
    }
    var headers = {
              login: 'mylogin',
              passcode: 'mypasscode',
              // additional header
              'client-id': '123456'
            };
    stompClient.send("/app/task/query", headers, JSON.stringify({ 'query': query, 'taskId': taskId, 'mode':mode}));
}

function greetingsCallBack(greeting) {
    showGreeting(JSON.parse(greeting.body).content);
}

function executeCallBack(statement) {
    alert('Trying to execute: '+statement);
}

function queryCallBack(statement) {
    var response = JSON.parse(statement.body);

    if (response.status === 'ERROR') {
        $("#resultContent").load("adm/console.html", function() {
            buildErrorBox(response);
            setSuccess(false);
        });
    } else if (response.type === 'execute') {
        $("#resultContent").load("adm/console.html", function() {
            buildConsoleBox(response);
            setSuccess(true);
        });
    } else {
        $("#resultContent").load("adm/result.html", function() {
            buildResultTables(response);
            setSuccess(response.correct);
        });
    }
}

function setSuccess(boolean) {
    if (boolean) {
        $('#succesLabel').show();
        $('#failLabel').hide();
    } else {
        $('#succesLabel').hide();
        $('#failLabel').show();
    }
}

function disconnect() {
    stompClient.disconnect(function() {
        console.log("Disconnected");
    });
}

function sendExecuteStmt() {
    var query = $('#queryTextArea').val();
    stompClient.send("/app/task/execute", {}, JSON.stringify({ 'query': query }));
}

function buildErrorBox(result) {
    $('#consoleBox').empty();
    var consoleBox = document.getElementById('consoleBox');
    var text = document.createTextNode(result.errorMessage);
    consoleBox.appendChild(text);

    $('#sendQueryBtn').button('reset');
}

function buildConsoleBox(result) {
    $('#consoleBox').empty();
    var consoleBox = document.getElementById('consoleBox');
    var text = document.createTextNode(result.consoleOutput);
    consoleBox.appendChild(text);

    $('#sendQueryBtn').button('reset');
}

function buildResultTables(result) {
    var actualTable, tableBody, tableHeader, expectedTable;

    $('#full-query').empty();
    var query = $('#queryTextArea').val();
    var label = document.getElementById('full-query');
    label.appendChild(document.createTextNode(query));

    $('#actual_table').empty();
    actualTable = document.getElementById('actual_table');
    tableHeader = getTableHeader(result.actualHeaders);
    tableBody = getTableBody(result.actual);
    actualTable.appendChild(tableHeader);
    actualTable.appendChild(tableBody);

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