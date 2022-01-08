<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Clienti</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="farmacii.css">
<link rel="stylesheet" href="clienti.css">
</head>
<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />
<body>
	<div class="navcontainer">
		<a class="logo" href="index.html">Portalul<span>Tau</span></a> <img
			id="mobileMenuIcon" class="mobileMenu" src="assets/menu48px.png"
			alt="Open Navigation">

		<div id="linksContainer" class="linksContainer">
			<ul>
				<li><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
				<li class="current"><a class="listItem" href="altiicatine.jsp">Altii
						ca tine</a></li>
				<li><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
			</ul>
		</div>

		<div id="linksContainerMobile" class="linksContainerMobile">
			<img id="mobileXIcon" class="mobileMenuX"
				src="assets/xButton48px.png" alt="Close Navigation">
			<ul class="mobileul">
				<li><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
				<li class="current"><a class="listItem" href="altiicatine.jsp">Altii
						ca tine</a></li>
				<li><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
			</ul>
		</div>
	</div>

	<section class="heroSection">

		<div class="heroContainer">
			<img class="heroImage" alt="Imagine client" src="assets/client.png">
			<h1 class="heroText">Aici poti vizualiza si modifica baza de
				date a clientilor</h1>
		</div>

	</section>

	<%
	jb.connect();
		
	String viewDisplay = "none";
	String messageDisplay = "none";
	String message="";
	String messageColor = "";
	
	if ( request.getParameter("vizualizeazaClient") != null ){
		String[] ids = request.getParameterValues("primarykey");
		if ( ids != null && ids.length > 1 ){
			message = "Va rog selectati un singur client";
			messageDisplay = "block";
		} else if ( ids != null && ids.length == 1 ){
			viewDisplay = "flex";
		} else {
			message = "Va rog sa selectati un client pentru vizualizare";
			messageDisplay = "block";
		}
		
		
	}

	if (request.getParameter("adaugaClient") != null) {
		response.sendRedirect("adaugaClient.jsp");
	}

	if (request.getParameter("deleteClient") != null) {
		String[] toDelete = request.getParameterValues("primarykey");
		
		if (toDelete != null) {
			jb.stergeDateTabela(toDelete, "clienti", "idclient");
			messageColor = "#32CD32";
			messageDisplay = "block";
			message = "Stergerea a fost efectuata cu succes";
		} else {
			messageColor = "#ff0000";
			messageDisplay = "block";
			message = "Va rog sa selectati una dintre casute pentru a sterge un client";
		}
	}
	
	if (request.getParameter("editClient") != null ) {
		String[] toDelete = request.getParameterValues("primarykey");
		if ( toDelete != null && toDelete.length == 1){
			RequestDispatcher rd = request.getRequestDispatcher("editClient.jsp");
			rd.forward(request, response);
		} else if ( toDelete != null && toDelete.length > 1){
			messageColor = "#ff0000";
			messageDisplay = "block";
			message = "Va rog sa selectati DOAR O SINGURA casuta pentru a edita un client";
		} else {
			messageColor = "#ff0000";
			messageDisplay = "block";
			message = "Va rog sa selectati una dintre casute pentru a edita un client";
		}
	}
	%>

	<form action="altiicatine.jsp" method="post">
		<section class="tableSection">
			<div class="tableContainer">

				<table>
					<tr class="header">
						<th>
							<h1></h1>
						</th>
						<th>
							<h1>nume</h1>
						</th>
						<th>
							<h1>prenume</h1>
						</th>
						<th>
							<h1>abonament premium</h1>
						</th>
					</tr>

					<%
                	ResultSet rs = jb.vedeTabela("clienti");
                	Long x;
                	
                	ArrayList<String> pks = new ArrayList<String>();
                	
                	if ( request.getParameterValues("primarykey") != null ){
						for ( String pk : request.getParameterValues("primarykey") ){
							pks.add(pk);
						}
                	}
                	
                	while(rs.next()){
                		x = rs.getLong("idclient");
                		String premium = "";
                		if ( rs.getBoolean("abonament_premium") == true ){
                			premium = "activ";
                		} else {
                			premium = "inactiv";
                		}
                	%>

					<tr>
						<td>
							<%
								if ( request.getParameterValues("primarykey") != null && pks.contains(x.toString())){
									
							%>
							<input type="checkbox" name="primarykey" value="<%= x%>" checked>
							<%
								} else {
							%>
							<input type="checkbox" name="primarykey" value="<%= x%>">
							<%
								}
							%>
						</td>
						<td>
							<h1>
								<%= rs.getString("nume") %>
							</h1>
						</td>
						<td>
							<h1>
								<%= rs.getString("prenume") %>
							</h1>
						</td>
						<td>
							<h1>
								<%= premium%>
							</h1>
						</td>
						<%
                		}
                    %>
					</tr>
				</table>
			</div>
		</section>
		
		<h1 class="alertMessage" style="display:<%=messageDisplay %>; color: <%=messageColor%>;"><%=message %></h1>
		
		<section class="inputsSection">
			<div class="buttonContainer">
				<input class="deleteButton" type="submit" value="Delete selected" name="deleteClient"> 
				<input class="editButton" type="submit" value="Edit selected" name="editClient"> 
				<input class="editButton" type="submit" value="Vizualizeaza" name="vizualizeazaClient"> 
				<input class="editButton" type="submit" value="Adauga client" name="adaugaClient">
			</div>
		</section>
	</form>
	
	<%
		if ( request.getParameter("vizualizeazaClient") != null){
			if (request.getParameter("primarykey") != null) {
				ResultSet client = jb.intoarceLinieDupaId("clienti", "idclient",
						Integer.parseInt(request.getParameter("primarykey")));
				client.next();
				String premium = "";
				if (client.getBoolean("abonament_premium") == true) {
					premium = "activ";
				} else {
					premium = "inactiv";
				}
				
	%>
	
	<section class="viewSection" id="viewSection" style="display:<%= viewDisplay%>;">
		<div class="viewSectionContainer">
			<h1 class="viewTitle">Vizualizare client</h1>
			<div class="viewClient">
				<label class="viewLabel" for="attrNume">Nume:</label>
				<p class="clientAttribute" name="attrNume"><%= client.getString("nume") %></p>
				<label class="viewLabel" for="attrPrenume">Prenume:</label>
				<p class="clientAttribute" name="attrPrenume"><%=client.getString("prenume") %></p>
				<label class="viewLabel" for="attrAdresa">Adresa:</label>
				<p class="clientAttribute" name="attrAdresa"><%= client.getString("adresa") %></p>
				<label class="viewLabel" for="attrContact">Contact:</label>
				<p class="clientAttribute" name="attrContact"><%= client.getString("contact") %></p>
				<label class="viewLabel" for="attrVarsta">Varsta:</label>
				<p class="clientAttribute" name="attrContact"><%= client.getInt("varsta") %></p>
				<label class="viewLabel" for="attrPremium">Abonament premium:</label>
				<p class="clientAttribute" name="attrPremium"><%=premium %></p>

			</div>
		</div>
	</section>

	<%
				client.close();
			}
		}
		rs.close();
		jb.disconnect();
	%>

	<section class="miscSection">
		<h1 class="miscText">Dragos Sandu 433A. Proiect Webapp cu jsp.
			PIBD</h1>
	</section>

	<script src="mobile.js"></script>
</body>
</html>