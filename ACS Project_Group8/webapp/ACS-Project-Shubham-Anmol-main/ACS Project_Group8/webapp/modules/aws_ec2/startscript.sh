#!/bin/bash

sudo yum -y install httpd

sudo cat > /var/www/html/index.html<< EOF
<!DOCTYPE html>
<html>
<head>
<title>Final Project Submitted by Group 8</title>
<style>
    body {
            font-family: Helvetica, Arial, sans-serif;
            font-weight: 600;
            font-size: 20pt;
            text-transform: uppercase;
            text-align: center;
            background: #4c724c;
            color: white;
    }
</style>
</head>
<h1>Final Project Submitted by Group8</h1>
<script language = "javascript">
        var imgArray = new Array();
        var bucket = "https://ssaxenabucket.s3.amazonaws.com/images/"
        var ext = ".jpg"
        for(i=0;i<10;i++){
            imgArray[i] = (bucket+i+ext);
        }
        function showImage(){
            var imgNum = Math.round(Math.random()*9);
            var objImg = document.getElementById("introImg");
            objImg.src = imgArray[imgNum];
        }
    </script>
<body onload = "showImage()">
        <img id = "introImg" border="0">
    </body>
</html>
EOF

sudo systemctl enable httpd
sudo systemctl start httpd