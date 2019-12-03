(function () {
    "use strict";
    
    // simple logger, bkrt fs15
    
    var messages = [];
    var dest = 'document';
    
    window.log = function (msg, elem) {
        if (msg === "to") {
            dest = elem;
            return;
        }
        if (dest === "console") {
            console.log(msg);
        }
        else {
            if (elem === undefined) { elem = 'div'; }
            if (msg === undefined)  { msg  = 'undefined'; }
            messages.push([msg, elem]);
            printlogs();
        }
    };
    
    function printlogs () {
        if (document.readyState === "complete") {
            var bodynode = document.getElementsByTagName('body')[0];
            var text, node;
            for (var i=0; i<messages.length; i+=1) {
                text = document.createTextNode(messages[i][0]);
                node = document.createElement(messages[i][1]);
                node.appendChild(text);
                bodynode.appendChild(node);
            }
            messages.length = 0;
        }
    }        
        
    if (window.onload) {
        var oldfunc = window.onload;
        window.onload = function() { 
            oldfunc(); 
            printlogs(); 
        };
    } else {
        window.onload = printlogs;
    }
    
    
})();