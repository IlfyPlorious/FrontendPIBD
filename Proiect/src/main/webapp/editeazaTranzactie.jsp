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
<title>Editare Tranzactie</title>
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
    		int primarykey = Integer.parseInt(request.getParameter("primarykey"));
	    	int idFarmacie = 0;
	    	int idClient = 0;
	        String idbon = request.getParameter("primarykey");
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
	    	
	    		String[] campuri = {"idfarmacie", "idclient", "produs", "cantitate_produs", "suma", "data", "tip_plata"};
	    		String[] campuriValues = {String.valueOf(idFarmacie), String.valueOf(idClient), produs, String.valueOf(cantitate), String.valueOf(suma), data, tipPlata};
	    		
	    		jb.modificaTabela("bonuriFiscale", "idbon", primarykey, campuri, campuriValues);
	    		
	 			response.sendRedirect("tranzactii.jsp");
	    			
	    	} else {
	    		messageDisplay = "block";
	    	}
    	
    		ResultSet rs = jb.vedeTabela("clienti");
    		String numePrenume = "";
    		
    		ResultSet bonCurent = jb.intoarceBonDupaID(primarykey);
    		bonCurent.next();
    		
    	%>
    
    	<section class="formSection">
        <div class="formContainer">
            <h1 class="title">Editeaza tranzactia cu nr. <%=idbon %></h1>
            <p class="alertMessage" style="display: <%= messageDisplay%>;"><%=message %></p>
            <form action="editeazaTranzactie.jsp" method="post">
            	<input type="number" name="primarykey" style="display:none" value=<%= request.getParameter("primarykey")%> > 
                <label class="label" for="clientSelect">Client:</label>
                <select class="selectBox" id="clientSelect" name="clientSelect" size="1">
                
                <%
                	while(rs.next()){
       					numePrenume = rs.getString("nume") + " " + rs.getString("prenume");
       					if ( rs.getInt("idclient") == bonCurent.getInt("idPacientBon") ){
       						
       					
                %>
                    <option value=<%=rs.getInt("idclient") %> selected><%=numePrenume %></option>
                <% 
       					} else {
       			%>
       	            <option value=<%=rs.getInt("idclient") %>><%=numePrenume %></option>
       	        <%
       					}
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
                		
                		if ( rsFarmacii.getInt("idfarmacie") == bonCurent.getInt("idFarmacieBon")){
                			
                		
                %>
                    <option value=<%=rsFarmacii.getInt("idfarmacie") %> selected><%=numeFarmacie %></option>
                <%
                		} else {
                %>
                    <option value=<%=rsFarmacii.getInt("idfarmacie") %>><%=numeFarmacie %></option>
                <%	
		                }
                		
                	}
                	rsFarmacii.close();
                %>
                </select></br>
                <label class="label" for="produsSelect">Produs:</label>
                <select class="selectBox" id="produsSelect" name="produsSelect" size="1" onchange="toggle()">
                    <%
                    	if ( bonCurent.getString("produs") == "paracetamol" ){
                    %>
                    <option value="paracetamol" selected>Paracetamol</option>
                    <%
                    	} else {
                    %>
                    <option value="paracetamol">Paracetamol</option>		
                    <% 
                    	}
                    	
                    	if ( bonCurent.getString("produs") == "nurofen" ){
                    %>
                    <option value="nurofen" selected>Nurofen</option>
                    <%
                    	} else {
                    %>
                    <option value="nurofen">Nurofen</option>
                    <%
                    	}
                    	
                   		 if ( bonCurent.getString("produs") == "furazolidon" ){
                    %>
                    <option value="furazolidon" selected>Furazolidon</option>
                    <%
                   		} else {
                    %>
                    <option value="furazolidon">Furazolidon</option>
                    <%
                   		}
                     	
                    	if ( bonCurent.getString("produs") == "clotrimazol" ){
                    %>
                    <option value="clotrimazol" selected>Clotrimazol</option>
                    <%
                    	} else {
                    %>
                    <option value="clotrimazol">Clotrimazol</option>
                    <%
                    	}
                    	
                    	if ( bonCurent.getString("produs") == "kerium" ){
                    %>
                    <option value="kerium" selected>Kerium DS</option>
                	<%
                    	} else {
                    %>
                    <option value="kerium">Kerium DS</option>
                    <%
                    	}
                    %>
                </select></br>
                <label class="label" for="cantitate">Cantitate:</label>
                <input class="numberBox" type="number" id="cantitate" name="cantitate" onchange="toggle()" min="1" max="100000" value=<%=bonCurent.getInt("cantitate_produs") %>></br>
                <div class="sumaContainer">
                    <label class="label" for="suma" id="sumaLabel">Suma:</label>
                    <input class="numberBox" type="number" name="suma" style="display: none;" id = "sumaDB" value=<%=bonCurent.getInt("suma") %>>
                    <p class="label" id="suma" name="sumaDisplay" ><%=bonCurent.getInt("suma") %></p> 
                    <p class="label" id="sumalei"> lei</p>
                </div>
                <label class="label" for="tipPlataSelect">Tip plata:</label>
                <select class="selectBox" id="tipPlataSelect" name="tipPlataSelect">
                    <%
                    	if ( bonCurent.getString("tip_plata") == "card" ){
                    %>
                    <option value="card" selected>Card</option>
                    <option value="numerar">Numerar</option>
                    <%
                    	} else {
                    %>
                    <option value="card">Card</option>
                    <option value="numerar" selected>Numerar</option>
                    <%
                    	}
                    %>
                    <option value="numerar">Numerar</option>
                </select><br>
                <label class="label" for="data">Data:</label>
                <input class="dateBox" type="date" id="dataTranzactie" name="dataTranzactie" value=<%=bonCurent.getString("data") %>></br>
                
                <div class="buttonContainer">
                    <input class="submitButton" type="submit" value="Salveaza" name="agaugaTranzactieButton">
                </div>
                
            </form>
        </div>
    </section>

    <script src="misc.js"></script>
    
    <%
    	bonCurent.close();
		jb.disconnect();
	%>
	
	<script src="mobile.js"></script>
</body>
</html>

