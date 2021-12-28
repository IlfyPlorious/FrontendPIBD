<%@page import="com.mysql.cj.jdbc.DatabaseMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%--
	Author: Sandu Dragos
--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Adauga Farmacie</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="adaugaFarmacii.css">
</head>
<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />
<body>
	<div class="navcontainer">
        <div class="logoContainer">
            <a class="logo" href="index.html">Portalul<span>Tau</span></a>
        </div>
        
        <img id="mobileMenuIcon" class="mobileMenu" src="assets/menu48px.png" alt="Open Navigation">

        <div id ="linksContainer" class="linksContainer">
            <ul>
                <li><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
                <li><a class="listItem" href="altiicatine.jsp">Altii ca tine</a></li>
                <li><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
            </ul>
        </div>

        <div id="linksContainerMobile" class="linksContainerMobile">
            <img id="mobileXIcon" class="mobileMenuX" src="assets/xButton48px.png" alt="Close Navigation">
            <ul class="mobileul">
                <li><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
                <li><a class="listItem" href="altiicatine.jsp">Altii ca tine</a></li>
                <li><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
            </ul>
        </div>
    </div>
    
    <%
    	/*try{
    		jb.connect();	
    	} catch ( Exception e ) {
    		RequestDispatcher rd = request.getRequestDispatcher("eroare.jsp");
			rd.forward(request, response);	
    	}*/ 
    	
    	jb.connect();
    	
    	String messageDisplay = "none";
    	String numeFarmacie = "";
    	String adresaFarmacie = "";
    	int preparate = -1;
    	int naturiste = -1;
    	String val = null;
    	
    	if ( request.getParameter("numeFarmacie") != null && request.getParameter("numeFarmacie") != "" ) {
    		numeFarmacie = request.getParameter("numeFarmacie");
    	}
    	
    	if ( request.getParameter("adresaFarmacie") != null && request.getParameter("adresaFarmacie") != "" ) {
    		adresaFarmacie = request.getParameter("adresaFarmacie");
    	}
    	
    	if ( request.getParameter("preparate") != null && request.getParameter("preparate") != "" ) {
    		if ( request.getParameter("preparate").equals("true")) {
    			preparate = 1;	
    		} else {
    			preparate = 0;
    		}
    	}
    	
    	if ( request.getParameter("naturiste") != null && request.getParameter("naturiste") != "" ) {
    		if ( request.getParameter("naturiste").equals("true")) {
    			naturiste = 1;	
    		} else {
    			naturiste = 0;
    		}
    	}
    	
    	if ( numeFarmacie != "" && adresaFarmacie != "" && preparate != -1 && naturiste != -1 ){
    	
    		jb.adaugaFarmacie(numeFarmacie, adresaFarmacie, preparate, naturiste);
    		
 			response.sendRedirect("farmacii.jsp");
    			
    	} else {
    		messageDisplay = "block";
    	}
    	
    		
    %>

    <section class="formSection">
        <div class="formContainer">
       		 <p class="title">Adauga o farmacie noua</p> 
        	 <p class="alertMessage" style="display: <%= messageDisplay%>;">Va rog sa completati toate campurile</p>
            <form action="adaugaFarmacie.jsp" method="post">
            	<input style="display:none" type="submit" name="adaugaFarmacieButton" value="<%= val%>">
                <label class="label" for="numeFarmacie">Nume:</label>
                <input class="textBox" type="text" id="numeFarmacie" name="numeFarmacie" value="<%= numeFarmacie%>"><br>
                <label class="label" for="adresaFarmacie">Adresa:</label>
                <input class="textBox" type="text" id="adresaFarmacie" name="adresaFarmacie" value="<%= adresaFarmacie%>">
                <p class="label">Ofera preparate:</p>
                <label class="label" for="daPreparate">Da</label>
                <input class="radioButton" type="radio" id="daPreparate" name="preparate" value="true"><br>
                <label class="label" for="nuPreparate">Nu</label>
                <input class="radioButton" type="radio" id="nuPreparate" name="preparate" value="false">
                <p class="label">Medicamente naturiste disponibile:</p>
                <label class="label" for="daNaturiste">Da</label>
                <input class="radioButton" type="radio" id="daNaturiste" name="naturiste" value="true"><br>
                <label class="label" for="nuNaturiste">Nu</label>
                <input class="radioButton" type="radio" id="nuNaturiste" name="naturiste" value="false"><br>
                <input class="submitButton" type="submit" value="Adauga Farmacie" name="agaugaFarmacieButton">
            </form>
        </div>
    </section>
	
	<%
		jb.disconnect();
	%>
	
	<script src="mobile.js"></script>
</body>
</html>