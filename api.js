//TILLEY:much better, will work with any number of calls made in sequence

function APIHandler(url,params, callback){
    this.callback = callback;
    this.params = params;
    this.url = url;
    //an example api calling method in javascript
    if (window.XMLHttpRequest){
        // code for IE7+, Firefox, Chrome, Opera, Safari
        this.xmlhttp=new XMLHttpRequest();
    }
    else{// code for IE6, IE5
        this.xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = this.wrap(this,"ajaxResponse");
}

APIHandler.prototype.start = function(){
    xmlhttp.open("POST",this.url,true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send(this.params);
}

APIHandler.prototype.ajaxResponse = function() {
    if (this.xmlhttp.readyState==4){
        if(this.xmlhttp.status==200){
            this.callback(eval(this.xmlhttp.responseText));
        }else{
            this.callback("Error" + this.xmlhttp.status + " on api call to " + this.url + " with parameters " + this.params);
        }
    }
}


APIHandler.prototype.wrap = function(obj, method) {
    return function() {
        obj[method]();
    }
}


function getUser(uid, callback){
    var handler = new APIHandler("our/site/url/getUser", "uid="+uid, callback);
    handler.start();
}

function getPuzzle(puzzleid, callback){
    var handler = new APIHandler("our/site/url/getUser", "puzzzleid="+puzzleid, callback);
    handler.start();
}