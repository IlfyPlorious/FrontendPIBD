<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MainPage</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="navcontainer">
        <a class="logo" href="index.html">Portalul<span>Tau</span></a>
        
        <img id="mobileMenuIcon" class="mobileMenu" src="assets/menu48px.png" alt="Open Navigation">

        <div id ="linksContainer" class="linksContainer">
            <ul>
                <li><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
                <li class="current"><a class="listItem" href="altiicatine.jsp">Altii ca tine</a></li>
                <li><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
            </ul>
        </div>

        <div id="linksContainerMobile" class="linksContainerMobile">
            <img id="mobileXIcon" class="mobileMenuX" src="assets/xButton48px.png" alt="Close Navigation">
            <ul class="mobileul">
                <li><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
                <li class="current"><a class="listItem" href="altiicatine.jsp">Altii ca tine</a></li>
                <li><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
            </ul>
        </div>
    </div>

    <script src="mobile.js"></script>
</body>
</html>