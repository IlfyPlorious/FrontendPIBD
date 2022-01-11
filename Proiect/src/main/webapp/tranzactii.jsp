<%@page import="java.util.ArrayList"%>
<%@page import="com.mysql.cj.jdbc.DatabaseMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tranzactii</title>
    <link rel="stylesheet" href="style.css">
	<link rel="stylesheet" href="farmacii.css">
	<link rel="stylesheet" href="tranzactii.css">
</head>
<jsp:useBean id="jb" scope="session" class="db.JavaBean" />
<jsp:setProperty name="jb" property="*" />
<body>
    <div class="navcontainer">
        <a class="logo" href="index.html">Portalul<span>Tau</span></a>
        
        <img id="mobileMenuIcon" class="mobileMenu" src="assets/menu48px.png" alt="Open Navigation">

        <div id ="linksContainer" class="linksContainer">
            <ul>
                <li><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
                <li><a class="listItem" href="altiicatine.jsp">Altii ca tine</a></li>
                <li class="current"><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
            </ul>
        </div>

        <div id="linksContainerMobile" class="linksContainerMobile">
            <img id="mobileXIcon" class="mobileMenuX" src="assets/xButton48px.png" alt="Close Navigation">
            <ul class="mobileul">
                <li><a class="listItem" href="farmacii.jsp">Farmacii</a></li>
                <li><a class="listItem" href="altiicatine.jsp">Altii ca tine</a></li>
                <li class="current"><a class="listItem" href="tranzactii.jsp">Tranzactii</a></li>
            </ul>
        </div>
    </div>
    
    <section class="heroSection">

		<div class="heroContainer">
			<img class="heroImage" alt="Imagine tranzactie"
				src="assets/bon.svg">
			<h1 class="heroText">Aici poti vizualiza si modifica baza de
				date cu tranzactii</h1>
		</div>

	</section>
	
	<%
		jb.connect();
		
		String messageDisplay = "none";
		String message = "Mesaj Informativ";
		String messageColor = "#32CD32";
		String add = "1";
		String viewDisplay = "none";
		
		if (request.getParameter("deleteTranzactieButton") != null ){
			String[] toDelete = request.getParameterValues("primarykey");
			if ( toDelete != null ){
				jb.stergeDateTabela(toDelete, "bonuriFiscale", "idbon");
				messageColor = "#32CD32";
				messageDisplay = "block";
				message = "Stergerea a fost efectuata cu succes";
			} else {
				messageColor = "#ff0000";
				messageDisplay = "block";
				message = "Va rog sa selectati una dintre casute pentru a sterge o tranzactie";
			}
		} else if (request.getParameter("editTranzactieButton") != null ) {
			String[] toDelete = request.getParameterValues("primarykey");
			if ( toDelete != null && toDelete.length == 1){
				RequestDispatcher rd = request.getRequestDispatcher("editeazaTranzactie.jsp");
				rd.forward(request, response);
			} else if ( toDelete != null && toDelete.length > 1){
				messageColor = "#ff0000";
				messageDisplay = "block";
				message = "Va rog sa selectati DOAR O SINGURA casuta pentru a edita o tranzactie";
			} else {
				messageColor = "#ff0000";
				messageDisplay = "block";
				message = "Va rog sa selectati una dintre casute pentru a edita o tranzactie";
			}
		} else if (request.getParameter("adaugaTranzactieButton") != null) {
			response.sendRedirect("cumpara.jsp");
		} else if ( request.getParameter("vizualizeazaTranzactieButton") != null ){
			String[] ids = request.getParameterValues("primarykey");
			if ( ids != null && ids.length > 1 ){
				messageColor = "#ff0000";
				message = "Va rog selectati o singura tranzactie pentru vizualizare";
				messageDisplay = "block";
			} else if ( ids != null && ids.length == 1 ){
				viewDisplay = "flex";
			} else {
				messageColor = "#ff0000";
				message = "Va rog sa selectati o tranzactie pentru vizualizare";
				messageDisplay = "block";
			}
			
			
		}
	%>

	<form action="tranzactii.jsp" method="post">
		<section class="tableSection">
			<div class="tableContainer">

				<table>
					<tr class="header">
						<th>
							<h1></h1>
						</th>
						<th>
							<h1>Vanzator</h1>
						</th>
						<th>
							<h1>Cumparator</h1>
						</th>
						<th>
							<h1>Produs</h1>
						</th>
						<th>
							<h1>Data</h1>
						</th>
					</tr>

					<%
                	ResultSet rs = jb.vedeBon();
				
					ArrayList<String> pks = new ArrayList<String>();
                	
                	if ( request.getParameterValues("primarykey") != null ){
						for ( String pk : request.getParameterValues("primarykey") ){
							pks.add(pk);
						}
                	}
					
                	Long x;
                	
                	while(rs.next()){
                		x = rs.getLong("idBonTranzactie");
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
								<%= rs.getString("numeFarmacie") %>
							</h1>
						</td>
						<td>
							<h1>
								<%= rs.getString("numeClient") %> <%=rs.getString("prenumeClient") %>
							</h1>
						</td>
						<td>
							<h1>
								<%= rs.getString("produs") %>
							</h1>
						</td>
						<td>
							<h1>
								<%= rs.getString("data") %>
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
				<input class="deleteButton" type="submit" value="Delete selected" name="deleteTranzactieButton">
				<input class="editButton" type="submit" value="Edit selected" name="editTranzactieButton">
				<input class="adaugaButton" type="submit" value="Efectueaza o tranzactie" name="adaugaTranzactieButton">
				<input class="adaugaButton" type="submit" value="Detalii Tranzactie" name="vizualizeazaTranzactieButton">	
			</div>
		</section>
	</form>
	
	<%
		if ( request.getParameter("vizualizeazaTranzactieButton") != null){
			if (request.getParameter("primarykey") != null) {
				ResultSet tranzactie = jb.intoarceBonDupaID(Integer.parseInt(request.getParameter("primarykey")));
				tranzactie.next();	
				Long idBon = tranzactie.getLong("idBonTranzactie");
				String tipPlata = "";
				if ( tranzactie.getString("tip_plata").equals("numerar")){
					tipPlata = "cash.svg";
				} else {
					tipPlata = "card.svg";
				}
	%>
	
	<section class="viewSection" id="viewSection" style="display:<%= viewDisplay%>;">
		<div class="viewSectionContainer">
			<h1 class="viewTitle">Bon fiscal nr. <%=idBon %></h1>
			<div class="viewClientContainer">
				<div class="viewClient">
					<label class="viewLabel" for="attrNumeClient">Client:</label>
					<p class="clientAttribute" name="attrNumeClient"><%= tranzactie.getString("numeClient") %> <%=tranzactie.getString("prenumeClient") %></p>
					<label class="viewLabel" for="attrContactClient">Contact client:</label>
					<p class="clientAttribute" name="attrContactClient"><%= tranzactie.getString("contactClient")%></p>
					<label class="viewLabel" for="attrAdresaClient">Adresa client:</label>
					<p class="clientAttribute" name="attrAdresaClient"><%= tranzactie.getString("adresaClient")%></p>
					<label class="viewLabel" for="attrVanzator">Vanzator:</label>
					<p class="clientAttribute" name="attrVanzator"><%=tranzactie.getString("numeFarmacie") %> Nr.Inregistrare <%=tranzactie.getString("idFarmacieBon") %></p>
					<label class="viewLabel" for="attrAdresaV">Adresa vanzator:</label>
					<p class="clientAttribute" name="attrAdresaV"><%=tranzactie.getString("adresaFarmacie") %></p>
					<label class="viewLabel" for="attrProdus">Produs:</label>
					<p class="clientAttribute" name="attrProdus"><%=tranzactie.getString("produs") %></p>
					<label class="viewLabel" for="attrCantitate">Cantitate:</label>
					<p class="clientAttribute" name="attrCantitate"><%=tranzactie.getString("cantitate_produs") %></p>
					<label class="viewLabel" for="attrCantitate">Suma [lei]:</label>
					<p class="clientAttribute" name="attrCantitate"><%=tranzactie.getString("suma") %></p>
					<label class="viewLabel" for="attrTipPlata">Tip plata:</label>
					<p class="clientAttribute" name="attrTipPlata"><%=tranzactie.getString("tip_plata") %></p>
					
				</div>
				 <img class="viewImg" src="assets/<%=tipPlata %>" alt="Imagine tip de plata">
			</div>
		</div>
	</section>

	<%
				tranzactie.close();
			}
		}
		rs.close();
		jb.disconnect();
	%>

	<section class="miscSection">
    <h1 class="miscText">Dragos Sandu 433A. Proiect Webapp cu jsp. PIBD</h1>
    </section>

    <script src="mobile.js"></script>
</body>
</html>