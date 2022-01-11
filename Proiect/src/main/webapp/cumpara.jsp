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
<title>Tranzactie in desfasurare</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="adaugaFarmacii.css">
<link rel="stylesheet" href="tranzExtra.css">
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
    		jb.connect();
    	
	    	String messageDisplay = "none";
	    	String message = "Va rog sa completati toate campurile";
	    	int idFarmacie = 0;
	    	int idClient = 0;
	    	String data = "";
	    	int suma = 0;
	    	String produs = "";
	    	String tipPlata = "";
	    	int cantitate = 0;
	    	
	    	if ( request.getParameter("clientSelect") != null ){
	    		idClient = Integer.parseInt(request.getParameter("clientSelect"));
	    	}
	    	
	    	if ( request.getParameter("farmacieSelect") != null ) {
	    		idFarmacie = Integer.parseInt(request.getParameter("farmacieSelect"));
	    	}
	    	
	    	if ( request.getParameter("produsSelect") != null ){
	    		produs = request.getParameter("produsSelect");
	    	}
	    	
	    	if ( request.getParameter("cantitate") != null && request.getParameter("cantitate") != "" ){
	    		cantitate = Integer.parseInt(request.getParameter("cantitate"));
	    	
	    		if ( cantitate < 1 || cantitate > 100000 ) {
	    			cantitate = 0;
	    			messageDisplay = "block";
	    			message = "Cantitatea poate lua valori intre 1 si 100000";
	    		}
	    	}
	    	
	    	if ( request.getParameter("tipPlataSelect") != null ){
	    		tipPlata = request.getParameter("tipPlataSelect");
	    	}
	    	
	    	if ( request.getParameter("suma") != null && request.getParameter("suma") != "" ){
	    		suma = Integer.parseInt(request.getParameter("suma"));
	    	}
			
	    	if ( request.getParameter("dataTranzactie") != null ){
	    		data = request.getParameter("dataTranzactie");
	    	}
	    	
	    	if ( idFarmacie != 0 && idClient != 0 && suma != 0 && cantitate != 0 && data != "" && tipPlata != "" && produs != "" ){
	    	
	    		jb.adaugaBon(idClient, idFarmacie, suma, produs, tipPlata, cantitate, data);
	    		
	 			response.sendRedirect("tranzactii.jsp");
	    			
	    	} else {
	    		messageDisplay = "block";
	    	}
    	
    		ResultSet rs = jb.vedeTabela("clienti");
    		String numePrenume = "";
    		
    		
    	%>
    
    	<section class="formSection">
        <div class="formContainer">
            <h1 class="title">Tranzactie in desfasurare</h1>
            <p class="alertMessage" style="display: <%= messageDisplay%>;"><%=message %></p>
            <form action="cumpara.jsp" method="post">
                <label class="label" for="clientSelect">Client:</label>
                <select class="selectBox" id="clientSelect" name="clientSelect" size="1">
                
                <%
                	while(rs.next()){
       					numePrenume = rs.getString("nume") + " " + rs.getString("prenume");
                %>
                    <option value=<%=rs.getInt("idclient") %>><%=numePrenume %></option>
                <% 
                	}
                
                	rs.close();
                %>
                </select></br>
                <label class="label" for="vanzatorSelect">Vanzator:</label>
                <select class="selectBox" id="vanzatorSelect" name="farmacieSelect" size="1">
                <%
                	String numeFarmacie = "";
                	ResultSet rsFarmacii = jb.vedeTabela("farmacii");
                	
                	while(rsFarmacii.next()){
                		
                		numeFarmacie = rsFarmacii.getString("nume") + ", " + rsFarmacii.getString("adresa");
                %>
                    <option value=<%=rsFarmacii.getInt("idfarmacie") %>><%=numeFarmacie %></option>
                <%
                	}
                	
                	rsFarmacii.close();
                %>
                </select></br>
                <label class="label" for="produsSelect">Produs:</label>
                <select class="selectBox" id="produsSelect" name="produsSelect" size="1" onchange="toggle()">
                    <option value="paracetamol">Paracetamol</option>
                    <option value="nurofen">Nurofen</option>
                    <option value="furazolidon">Furazolidon</option>
                    <option value="clotrimazol">Clotrimazol</option>
                    <option value="kerium">Kerium DS</option>
                </select></br>
                <label class="label" for="cantitate">Cantitate:</label>
                <input class="numberBox" type="number" id="cantitate" name="cantitate" onchange="toggle()" min="1" max="100000"></br>
                <div class="sumaContainer">
                    <label class="label" for="suma" id="sumaLabel">Suma:</label>
                    <input class="numberBox" type="number" name="suma" style="display: none;" id = "sumaDB">
                    <p class="label" id="suma" name="sumaDisplay">0</p> 
                    <p class="label" id="sumalei"> lei</p>
                </div>
                <label class="label" for="tipPlataSelect">Tip plata:</label>
                <select class="selectBox" id="tipPlataSelect" name="tipPlataSelect">
                    <option value="card">Card</option>
                    <option value="numerar">Numerar</option>
                </select><br>
                <label class="label" for="data">Data:</label>
                <input class="dateBox" type="date" id="dataTranzactie" name="dataTranzactie"></br>
                
                <div class="buttonContainer">
                    <input class="submitButton" type="submit" value="Cumpara" name="agaugaTranzactieButton">
                </div>
                
            </form>
        </div>
    </section>

    <script src="misc.js"></script>
    
    <%
		jb.disconnect();
	%>
	
	<script src="mobile.js"></script>
</body>
</html>

