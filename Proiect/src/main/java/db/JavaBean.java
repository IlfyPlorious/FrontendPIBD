package db;
import java.sql.*;
import java.text.DateFormat;
import java.text.FieldPosition;
import java.text.ParsePosition;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

import javax.swing.text.DateFormatter;
/**
 *
 * @author Dragos Sandu 433A
 */
public class JavaBean {
	String error;
	Connection con;
	public JavaBean() {
	}
	public void connect() throws ClassNotFoundException, SQLException, Exception {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/farmacii?useSSL=false","root", "parolasigura");
		} catch (ClassNotFoundException cnfe) {
			error = "ClassNotFoundException: Nu s-a gasit driverul bazei de date.";
			throw new ClassNotFoundException(error);
		} catch (SQLException cnfe) {
			error = "SQLException: Nu se poate conecta la baza de date.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "Exception: A aparut o exceptie neprevazuta in timp ce se stabilea legatura la baza de date.";
					throw new Exception(error);
		}
	} // connect()
	
	public DatabaseMetaData getMetaData() throws SQLException {
		return con.getMetaData();
	}
	
	public void connect(String bd) throws ClassNotFoundException, SQLException, Exception {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + bd, "root",
					"parolasigura");
		} catch (ClassNotFoundException cnfe) {
			error = "ClassNotFoundException: Nu s-a gasit driverul bazei de date.";
			throw new ClassNotFoundException(error);
		} catch (SQLException cnfe) {
			error = "SQLException: Nu se poate conecta la baza de date.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "Exception: A aparut o exceptie neprevazuta in timp ce se stabilea legatura la baza de date.";
					throw new Exception(error);
		}
	} // connect(String bd)
	public void connect(String bd, String ip) throws ClassNotFoundException, SQLException,
	Exception {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://" + ip + ":3306/" + bd, "root",
					"parolasigura");
		} catch (ClassNotFoundException cnfe) {
			error = "ClassNotFoundException: Nu s-a gasit driverul bazei de date.";
			throw new ClassNotFoundException(error);
		} catch (SQLException cnfe) {
			error = "SQLException: Nu se poate conecta la baza de date.";
			throw new SQLException(error);} catch (Exception e) {
				error = "Exception: A aparut o exceptie neprevazuta in timp ce se stabilea legatura la baza de date.";
						throw new Exception(error);
			}
	} // connect(String bd, String ip)
	public void disconnect() throws SQLException {
		try {
			if (con != null) {
				con.close();
			}
		} catch (SQLException sqle) {
			error = ("SQLException: Nu se poate inchide conexiunea la baza de date.");
			throw new SQLException(error);
		}
	} // disconnect()
	public void adaugaClient(String nume, String prenume, String adresa, String contact, int varsta, int abonamentPremium)
			throws SQLException, Exception {
		if (con != null) {
			try {
				// creaza un "prepared SQL statement"
				Statement stmt;
				stmt = con.createStatement();
				stmt.executeUpdate("insert into clienti(nume, prenume, adresa, contact, varsta, abonament_premium) values('" + nume
						+ "' , '" + prenume + "', '" + adresa + "', '" + contact + "', '" + varsta + "', '" + abonamentPremium + "');");
			} catch (SQLException sqle) {
				error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	} // end of adaugaClient()
	
	public void adaugaFarmacie(String nume, String adresa, int oferaPreparate, int medicamenteNaturiste)
			throws SQLException, Exception {
		if (con != null) {
			try {
				// creaza un "prepared SQL statement"
				Statement stmt;stmt = con.createStatement();
				stmt.executeUpdate("insert into farmacii(nume, adresa, ofera_preparate, medicamente_naturiste) values('" + nume +
						"' , '" + adresa + "', '" + oferaPreparate + "', '" + medicamenteNaturiste + "');");
			} catch (SQLException sqle) {
				error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	} // end of adaugaFarmacie()
	
	public void adaugaBon(int idclient, int idfarmacie, float suma, String produs, 
			String tipDePlata, float cantitateProdus)
					throws SQLException, Exception {
		if (con != null) {
			try {
				// creaza un "prepared SQL statement"
				Statement stmt;
				stmt = con.createStatement();
				stmt.executeUpdate("insert into bonuriFiscale(idclient, idfarmacie, data, suma, produs,	tip_plata, cantitate_produs) values('" + 
						idclient + "' , '" + idfarmacie + "', '" + getCurrentDate() +
								"', '" + suma + "', '" + produs + "', '" + tipDePlata + "', '" + cantitateProdus + "');");
				
			} catch (SQLException sqle) {
				error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	} // end of adaugaBon()
	
	
	public ResultSet vedeTabela(String tabel) throws SQLException, Exception {
		ResultSet rs = null;
		try {
			String queryString = ("select * from `farmacii`.`" + tabel + "`;");
			Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY*/);
			rs = stmt.executeQuery(queryString);
		} catch (SQLException sqle) {
			error = "SQLException: Interogarea nu a fost posibila.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "A aparut o exceptie in timp ce se extrageau datele.";
			throw new Exception(error);
		}
		return rs;
	} // vedeTabela()
	public ResultSet vedeBon() throws SQLException, Exception {
		ResultSet rs = null;
		try {
			String queryString = ("SELECT c.nume numeClient,c.prenume prenumeClient,c.abonament_premium,f.nume numeFarmacie,f.adresa adresaFarmacie,b.idbon,b.idfarmacie idFarmacieBon,b.idclient idPacientBon,b.data, b.produs, b.cantitate_produs, b.suma FROM farmacii f, clienti c, bonuriFiscale b WHERE c.idclient = b.idclient AND f.idfarmacie = b.idfarmacie;");
					Statement stmt = con.createStatement(/*ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY*/);
					rs = stmt.executeQuery(queryString);
		} catch (SQLException sqle) {
			error = "SQLException: Interogarea nu a fost posibila.";
			throw new SQLException(error);
		} catch (Exception e) {
			error = "A aparut o exceptie in timp ce se extrageau datele.";
			throw new Exception(error);
		}
		return rs;
	} // vedeBon()
	public void stergeDateTabela(String[] primaryKeys, String tabela, String dupaID) throws
	SQLException, Exception {
		if (con != null) {
			try {
				// creaza un "prepared SQL statement"
				long aux;
				PreparedStatement delete;
				delete = con.prepareStatement("DELETE FROM " + tabela + " WHERE " + dupaID + "=?;");
				for (int i = 0; i < primaryKeys.length; i++) {
					aux = java.lang.Long.parseLong(primaryKeys[i]);
					delete.setLong(1, aux);delete.execute();
				}
			} catch (SQLException sqle) {
				error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			} catch (Exception e) {
				error = "A aparut o exceptie in timp ce erau sterse inregistrarile.";
				throw new Exception(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	} // end of stergeDateTabela()
	public void stergeTabela(String tabela) throws SQLException, Exception {
		if (con != null) {
			try {
				// creaza un "prepared SQL statement"
				Statement stmt;
				stmt = con.createStatement();
				stmt.executeUpdate("delete from " + tabela + ";");
			} catch (SQLException sqle) {
				error = "ExceptieSQL: Stergere nereusita; este posibil sa existe duplicate.";
				throw new SQLException(error);
			}
		} else {
			error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
			throw new Exception(error);
		}
	} // end of stergeTabela()
	public void modificaTabela(String tabela, String IDTabela, int ID, String[] campuri, String[]
			valori) throws SQLException, Exception {
		String update = "update " + tabela + " set ";
		String temp = "";
		if (con != null) {
			try {
				for (int i = 0; i < campuri.length; i++) {
					if (i != (campuri.length - 1)) {
						temp = temp + campuri[i] + "='" + valori[i] + "', ";
					} else {
						temp = temp + campuri[i] + "='" + valori[i] + "' where " + IDTabela + " = '" + ID + "';";}
					}
					update = update + temp;
					// creaza un "prepared SQL statement"
					Statement stmt;
					stmt = con.createStatement();
					stmt.executeUpdate(update);
				} catch (SQLException sqle) {
					error = "ExceptieSQL: Reactualizare nereusita; este posibil sa existe duplicate.";
					throw new SQLException(error);
				}
			} else {
				error = "Exceptie: Conexiunea cu baza de date a fost pierduta.";
				throw new Exception(error);
			}
		} // end of modificaTabela()
//		public ResultSet intoarceLinie(String tabela, int ID) throws SQLException, Exception {
//			ResultSet rs = null;
//			try {
//				// Executa interogarea
//				String queryString = ("SELECT * FROM " + tabela + " where idpacient=" + ID + ";");
//				Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
//						ResultSet.CONCUR_READ_ONLY);
//				rs = stmt.executeQuery(queryString); //sql exception
//			} catch (SQLException sqle) {
//				error = "SQLException: Interogarea nu a fost posibila.";
//				throw new SQLException(error);
//			} catch (Exception e) {
//				error = "A aparut o exceptie in timp ce se extrageau datele.";
//				throw new Exception(error);
//			}
//			return rs;
//		} // end of intoarceLinie()
		public ResultSet intoarceLinieDupaId(String tabela, String denumireId, int ID) throws
		SQLException, Exception {
			ResultSet rs = null;
			try {
				// Executa interogarea
				String queryString = ("SELECT * FROM " + tabela + " where " + denumireId + "=" + ID +
						";");
				Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);rs = stmt.executeQuery(queryString); //sql exception
			} catch (SQLException sqle) {
				error = "SQLException: Interogarea nu a fost posibila.";
				throw new SQLException(error);
			} catch (Exception e) {
				error = "A aparut o exceptie in timp ce se extrageau datele.";
				throw new Exception(error);
			}
			return rs;
		} // end of intoarceLinieDupaId()
		public ResultSet intoarceBonDupaID(int ID) throws SQLException, Exception {
			ResultSet rs = null;
			try {
				// Executa interogarea
				String queryString = ("SELECT c.nume numeClient,c.prenume prenumeClient,c.abonament_premium,f.nume numeFarmacie,f.adresa adresaFarmacie,b.idbon,b.idfarmacie idFarmacieBon,b.idclient idPacientBon,b.data, b.produs, b.cantitate_produs, b.suma FROM farmacii f, clienti c, bonuriFiscale b WHERE c.idclient = b.idclient AND f.idfarmacie = b.idfarmacie AND b.idbon = " +
						ID + "';");
				Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
				rs = stmt.executeQuery(queryString); //sql exception
			} catch (SQLException sqle) {
				error = "SQLException: Interogarea nu a fost posibila.";
				throw new SQLException(error);
			} catch (Exception e) {
				error = "A aparut o exceptie in timp ce se extrageau datele.";
				throw new Exception(error);
			}
			return rs;
		} // end of intoarceLinieDupaId()
		
		private String getCurrentDate() {
			String date;
			LocalDateTime localDateTime = LocalDateTime.now();
			date = localDateTime.format(DateTimeFormatter.ofPattern("yyyy.mm.dd"));
			
			return date;
		}
	}