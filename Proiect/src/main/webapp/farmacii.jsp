<%@page import="jdk.internal.util.xml.impl.Input"%>
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
<title>Farmacii</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="farmacii.css">
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
				<li class="current"><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
				<li><a class="listItem" href="altiicatine.jsp">Altii ca
						tine</a></li>
				<li><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
			</ul>
		</div>

		<div id="linksContainerMobile" class="linksContainerMobile">
			<img id="mobileXIcon" class="mobileMenuX"
				src="assets/xButton48px.png" alt="Close Navigation">
			<ul class="mobileul">
				<li class="current"><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
				<li><a class="listItem" href="altiicatine.jsp">Altii ca
						tine</a></li>
				<li><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
			</ul>
		</div>
	</div>

	<section class="heroSection">

		<div class="heroContainer">
			<img class="heroImage" alt="Imagine farmacie"
				src="assets/farmacie.png">
			<h1 class="heroText">Aici poti vizualiza si modifica baza de
				date cu farmacii</h1>
		</div>

	</section>
	
	<%
		jb.connect();
		
		String messageDisplay = "none";
		String message = "Mesaj Informativ";
		String messageColor = "#32CD32";
		String add = "1";
		
		if (request.getParameter("deleteFarmacieButton") != null ){
			String[] toDelete = request.getParameterValues("primarykey");
			if ( toDelete != null ){
				jb.stergeDateTabela(toDelete, "farmacii", "idfarmacie");
				messageColor = "#32CD32";
				messageDisplay = "block";
				message = "Stergerea a fost efectuata cu succes";
			} else {
				messageColor = "#ff0000";
				messageDisplay = "block";
				message = "Va rog sa selectati una dintre casute pentru a sterge o farmacie";
			}
		} else if (request.getParameter("editFarmacieButton") != null ) {
			String[] toDelete = request.getParameterValues("primarykey");
			if ( toDelete != null && toDelete.length == 1){
				RequestDispatcher rd = request.getRequestDispatcher("editeazaFarmacie.jsp");
				rd.forward(request, response);
			} else if ( toDelete != null && toDelete.length > 1){
				messageColor = "#ff0000";
				messageDisplay = "block";
				message = "Va rog sa selectati DOAR O SINGURA casuta pentru a edita o farmacie";
			} else {
				messageColor = "#ff0000";
				messageDisplay = "block";
				message = "Va rog sa selectati una dintre casute pentru a edita o farmacie";
			}
		} else if (request.getParameter("adaugaFarmacieButton") != null) {
			response.sendRedirect("adaugaFarmacie.jsp");
		}
	%>

	<form action="farmacii.jsp" method="post">
		<section class="tableSection">
			<div class="tableContainer">

				<table>
					<tr class="header">
						<th>
							<h1>id</h1>
						</th>
						<th>
							<h1>nume</h1>
						</th>
						<th>
							<h1>adresa</h1>
						</th>
						<th>
							<h1>preparate</h1>
						</th>
						<th>
							<h1>medicamente naturiste</h1>
						</th>
					</tr>

					<%
                	ResultSet rs = jb.vedeTabela("farmacii");
                	long x;
                	while(rs.next()){
                		x = rs.getLong("idfarmacie");
                		String preparate = "";
                		String naturiste = "";
                		if ( rs.getBoolean("ofera_preparate") == true ){
                			preparate = "Da";
                		} else {
                			preparate = "Nu";
                		}
                		if ( rs.getBoolean("medicamente_naturiste") == true ){
                			naturiste = "Da";
                		} else {
                			naturiste = "Nu";
                		}
                	%>

					<tr>
						<td><input type="checkbox" name="primarykey" value="<%= x%>">
						</td>
						<td>
							<h1>
								<%= rs.getString("nume") %>
							</h1>
						</td>
						<td>
							<h1>
								<%= rs.getString("adresa") %>
							</h1>
						</td>
						<td>
							<h1>
								<%= preparate%>
							</h1>
						</td>
						<td>
							<h1>
								<%= naturiste%>
							</h1>
						</td>
						<%
                		}
                    %>
					</tr>
				</table>
			</div>
		</section>

		<h1 class="alertMessage" style="display: <%= messageDisplay%>; color: <%= messageColor%>;"><%=message %></h1>
	
		<section class="inputsSection">
			<div class="buttonContainer">
				<input class="deleteButton" type="submit" value="Delete selected" name="deleteFarmacieButton">
				<input class="editButton" type="submit" value="Edit selected" name="editFarmacieButton">
				<input class="adaugaButton" type="submit" value="Adauga farmacie noua" name="adaugaFarmacieButton">
			</div>
		</section>
	</form>
	
	<%
		rs.close();
		jb.disconnect();
	%>
	
	<section class="miscSection">
        <h1 class="miscText">Dragos Sandu 433A. Proiect Webapp cu JDBC. PIBD</h1>
    </section>
	
	
	<script src="mobile.js"></script>
</body>
</html>