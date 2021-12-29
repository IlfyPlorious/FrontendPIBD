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
<title>Editeaza Client</title>
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
    	String message = "";
    	String numeClient = "";
    	String prenumeClient = "";
    	String adresaClient =""; 
    	String contactClient = "";
    	String premiumV = "";
    	Integer varstaClient = -1;
    	Integer premium = -1;
    	int primarykey = Integer.parseInt(request.getParameter("primarykey"));
    	
    	ResultSet rs = jb.intoarceLinieDupaId("clienti", "idclient", Integer.parseInt(request.getParameter("primarykey")));
    	rs.first();
    	numeClient = rs.getString("nume");
    	prenumeClient = rs.getString("prenume");
    	adresaClient = rs.getString("adresa");
    	contactClient = rs.getString("contact");
    	varstaClient = rs.getInt("varsta");
    	premium = rs.getInt("abonament_premium");
    	
    	if ( premium == 1){
    		premiumV = "Activ";
    	} else {
    		premiumV = "Inactiv";
    	}
    	
    	if ( request.getParameter("numeClient") != null && request.getParameter("numeClient") != "" ) {
    		numeClient = request.getParameter("numeClient");
    	}
    	
    	if ( request.getParameter("prenumeClient") != null && request.getParameter("prenumeClient") != "" ) {
    		prenumeClient = request.getParameter("prenumeClient");
    	}
    	
    	if ( request.getParameter("adresaClient") != null && request.getParameter("adresaClient") != "" ) {
    		adresaClient = request.getParameter("adresaClient");
    	}
    	
    	if ( request.getParameter("contactClient") != null && request.getParameter("contactClient") != "" ) {
    		contactClient = request.getParameter("contactClient");
    	}
    	
    	if ( request.getParameter("varstaClient") != null ){
    		varstaClient = Integer.parseInt(request.getParameter("varstaClient"));
    		if ( varstaClient < 0 ){
    			message = "Varsta introdusa nu are formatul corect";
    			messageDisplay = "block";
    		}
    	}
    	
    	if ( request.getParameter("premium") != null && request.getParameter("premium") != "" ) {
    		if ( request.getParameter("premium").equals("true")) {
    			premium = 1;	
    		} else {
    			premium = 0;
    		}
    	}
    	
    	if ( request.getParameter("editClientButton") != null ){
    		if ( numeClient != "" && prenumeClient != "" && adresaClient != "" 
        			&& contactClient != "" && varstaClient > 0 && premium != -1 ){
        		
        		String[] campuri = {"nume", "prenume", "adresa", "contact", "varsta", "abonament_premium"};
        		String[] valori = {numeClient, prenumeClient, adresaClient, contactClient, varstaClient.toString(), premium.toString()};
        	
        		jb.modificaTabela("clienti", "idclient", primarykey, campuri, valori);
        		
     			response.sendRedirect("altiicatine.jsp");
        			
        	} else {
        		if ( varstaClient > 0 )
        			message = "Va rog sa completati toate campurile";
        		
        		messageDisplay = "block";
        	}
    	}
    		
    %>

    <section class="formSection">
        <div class="formContainer">
       		 <p class="title">Editeaza clientul selectat</p> 
        	 <p class="alertMessage" style="display: <%= messageDisplay%>;"><%=message %></p>
            <form action="editClient.jsp" method="post">
            	<input type="number" style="display:none" name="primarykey" value=<%= primarykey %>>
                <label class="label" for="numeClient">Nume:</label>
                <input class="textBox" type="text" id="numeClient" name="numeClient" value="<%= numeClient%>"><br>
                <label class="label" for="prenumeClient">Prenume:</label>
                <input class="textBox" type="text" id="prenumeClient" name="prenumeClient" value="<%= prenumeClient%>"><br>
                <label class="label" for="adresaClient">Adresa:</label>
                <input class="textBox" type="text" id="adresaClient" name="adresaClient" value="<%= adresaClient%>"><br>
                <label class="label" for="contactClient">Contact:</label>
                <input class="textBox" type="text" id="contactClient" name="contactClient" value="<%= contactClient%>"><br>
                <label class="label" for="varstaClient">Varsta:</label>
                <input class="number" type="number" id="varstaClient" name="varstaClient" value="<%= varstaClient%>"><br>
                <p class="label">Abonament premium: <%=premiumV %> (curent)</p>
                <label class="label" for="activ">Activ</label>
                <input class="radioButton" type="radio" id="activ" name="premium" value="true"><br>
                <label class="label" for="inactiv">Inactiv</label>
                <input class="radioButton" type="radio" id="inactiv" name="premium" value="false"><br>
                <input class="submitButton" type="submit" value="Editeaza Client" name="editClientButton">
            </form>
        </div>
    </section>
	
	<%
		jb.disconnect();
	%>
	
	<script src="mobile.js"></script>
</body>
</html>