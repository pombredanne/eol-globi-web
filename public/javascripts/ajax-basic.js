
var http
// var domainurl = "http://rob.wildgigs.com";

// function sendToken(token){
//    var myurl = domainurl + "/createfb.text";
//    http = getHTTPObject();
//    http.open("POST", myurl, true);
//    http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
//    http.setRequestHeader("Connection", "Keep-Alive");
// 
//    http.onreadystatechange = useHttpResponse;
//    http.send('token=' + token);
// }

function getHTTPObject() {
   if (typeof XMLHttpRequest != 'undefined') {
       return new XMLHttpRequest();
   }
   try {
       return new ActiveXObject("Msxml2.XMLHTTP");
   } catch (e) {
       try {
           return new ActiveXObject("Microsoft.XMLHTTP");
       } catch (e) {
           alert(e);
       }
   }
   return false;
}

function useHttpResponse() {
    if (http.readyState == 4 && this.status == 200) {
        resp = http.responseText;
        if (resp == 'no'){
            alert('Oh no! An Error occured. Please try again later or use the regular login process.');
        } else if (resp == 'loggedin') {
            // nothing to do.
        } else {
            window.location.href = http.responseText;
        }
    }
}
