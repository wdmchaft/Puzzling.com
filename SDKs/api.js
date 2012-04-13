//TILLEY:much better, will work with any number of calls made in sequence

function APIHandler(url,params, method, callback){
    this.callback = callback;
    this.params = params;
    this.url = BASE_URL + url;
    this.method = method;
    //an example api calling method in javascript
    if (window.XMLHttpRequest){
        // code for IE7+, Firefox, Chrome, Opera, Safari
        this.xmlhttp=new XMLHttpRequest();
    }
    else{// code for IE6, IE5
        this.xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    this.xmlhttp.onreadystatechange = this.wrap(this,"ajaxResponse");
}

APIHandler.prototype.start = function(){
    if(this.method == "POST"){
        this.xmlhttp.open("POST",this.url,true);
        this.xmlhttp.setRequestHeader("Content-type","text/plain;charset=UTF-8");
        console.log(serialize(this.params));
        this.xmlhttp.send(serialize(this.params));
    }else if(this.method == "GET"){
        this.xmlhttp.open("GET",this.url + "?" + urlify(this.params),true);
        this.xmlhttp.send();
    }else if(this.method == "DELETE"){
        this.xmlhttp.open("DELETE",this.url + "?" + urlify(this.params),true);
        this.xmlhttp.send();
    }
}

APIHandler.prototype.ajaxResponse = function() {
    if (this.xmlhttp.readyState==4){
        if(this.xmlhttp.status==200){
            this.callback(this.xmlhttp.responseText);
        }else{
            this.callback("Error " + this.xmlhttp.status + " on api call to " + this.url + " with parameters " + this.params);
        }
    }
}


APIHandler.prototype.wrap = function(obj, method) {
    return function() {
        obj[method]();
    }
}

//HELPER METHODS//

//http://www.dotnetfunda.com/articles/article763-serialize-object-in-javascript.aspx
function serialize(obj){
    var returnVal;
    if(obj != undefined){
        switch(obj.constructor){
            case Array:
                var vArr="[";
                for(var i=0;i<obj.length;i++){
                    if(i>0) vArr += ",";
                    vArr += serialize(obj[i]);
                    }
                    vArr += "]"
                    return vArr;
            case String:
                returnVal = "'" + escape(obj) + "'";
                return returnVal;
            case Number:
                returnVal = isFinite(obj) ? obj.toString() : null;
                return returnVal;    
            case Date:
                returnVal = "#" + obj + "#";
                return returnVal;  
            default:
                if(typeof obj == "object"){
                    var vobj=[];
                    for(attr in obj){
                        if(typeof obj[attr] != "function"){
                            vobj.push('"' + attr + '":' + serialize(obj[attr]));
                        }
                    }if(vobj.length >0)
                        return "{" + vobj.join(",") + "}";
                    else
                        return "{}";
                }else{
                    return obj.toString();
                }
        }
    }
    return null;
}

function urlify(obj){
    //needs to be an associative array
    var result = ""
    for(var key in obj){
        result += key + "=" + obj[key];
        result += "&"
    }
    return result.substring(0,result.length-1);
}

//


//CONSTANTS//

var BASE_URL = "http://www.stanford.edu/~jtilley/cgi-bin";

//END CONSTS//


//API METHODS//
function getAuthTokenForUser(username, password, callback){
    var handler = new APIHandler("/login",
                                 {username: username, password:password},
                                 "GET",
                                 callback);
    handler.start();
}

function createUser(username, password, userdata, callback){
    var handler = new APIHandler("/login",
                                 {username: username, password:password, userdata:userdata},
                                 "POST",
                                 callback);
    handler.start();
}


function getUser(uid, callback){
    var handler = new APIHandler("http://www.stanford.edu/~jtilley/cgi-bin/phpinfo.php", "{uid:"+uid+"}", "POST", callback);
    handler.start();
}

function getPuzzle(puzzleid, callback){
    var handler = new APIHandler("our/site/url/getPuzzle", "puzzzleid="+puzzleid, "POST", callback);
    handler.start();
}

//END API METHODS//