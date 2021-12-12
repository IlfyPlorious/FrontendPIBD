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
<title>MainPage</title>
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
		
		String message = "none";
	
		if (request.getParameter("deleteFarmacieButton") != null ){
			String[] toDelete = request.getParameterValues("primarykey");
			if ( toDelete != null ){
				jb.stergeDateTabela(toDelete, "farmacii", "idfarmacie");
				message = "block";
			}
		} else if (request.getParameter("editFarmacieButton") != null ) {
			
		} else if (request.getParameter("adaugaFarmacieButton") != null ) {
			RequestDispatcher rd = request.getRequestDispatcher("tranzactii.jsp");
			rd.forward(request, response);
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
								<%= rs.getBoolean("ofera_preparate")%>
							</h1>
						</td>
						<td>
							<h1>
								<%= rs.getBoolean("medicamente_naturiste") %>
							</h1>
						</td>
						<%
                		}
                    %>
					</tr>
				</table>
			</div>
		</section>

		<h1 class="alertMessage" style="display: <%= message%>">Stergerea a fost efectuata cu succes</h1>
	
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
	
	<script src="mobile.js"></script>
</body>
</html>