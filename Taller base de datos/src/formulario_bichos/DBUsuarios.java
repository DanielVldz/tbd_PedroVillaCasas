package formulario_bichos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.table.DefaultTableModel;

public class DBUsuarios extends DBConexion
{
	public static Usuario getUsuraioPorID(int id) throws SQLException
	{
		int victorias = 0;
		String nombre = "";
		Connection con = GetConnection();
		String query = "SELECT usuario.id, usuario.nombre from usuario where usuario.id = " + id;
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		rs.next();
		nombre = rs.getString(2);

		query = "select count(*) from combate left join usuario on usuario.id = combate.id_entrenador1 or usuario.id = combate.id_entrenador2 where usuario.id = " + id;
		if (rs.next())
		{
			victorias = rs.getInt(1);
		}

		return generarUsuario(id, nombre, victorias);
	}

	private static Usuario generarUsuario(int id, String nombre, int victorias) throws SQLException
	{
		Usuario u = new Usuario();
		u.setId(id);
		u.setNombre(nombre);
		u.setCombatesGanados(victorias);
		return u;
	}

	public static DefaultTableModel bichosUsuario(int id) throws SQLException
	{
		String encabezado[] = { "Nombre", "Especie", "Nivel" };
		String renglon[] = new String[3];
		DefaultTableModel dtm = new DefaultTableModel(encabezado, 0);
		Connection con = GetConnection();
		String query = "SELECT * FROM bichosUsuario WHERE id = " + id;
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();

		while (rs.next())
		{
			renglon[0] = rs.getString(2) == null ? "Sin nombre" : rs.getString(2);
			renglon[1] = rs.getString(3);
			renglon[2] = "" + rs.getInt(4);
			dtm.addRow(renglon);
		}
		con.close();
		return dtm;
	}

	public static String[] listaUsuarios() throws SQLException
	{
		Connection con = GetConnection();
		int i = 0;
		String query = "SELECT COUNT(*) FROM usuario";
		String datos[];
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		rs.next();
		datos = new String[rs.getInt(1)];

		query = "SELECT id FROM usuario";
		st = con.prepareStatement(query);
		rs = st.executeQuery();

		while (rs.next())
		{
			datos[i] = "" + rs.getInt(1);
			i++;
		}
		return datos;
	}

	public static int maxUsuario() throws SQLException
	{
		Connection con = GetConnection();
		String query = "SELECT MAX(id) FROM usuario";
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		rs.next();
		return rs.getInt(1);
	}
	
	public static int minUsuario() throws SQLException
	{
		Connection con = GetConnection();
		String query = "SELECT MIN(id) FROM usuario";
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		rs.next();
		return rs.getInt(1);
	}

	public static void capturarBicho(int usuario, int bicho, String nombre) throws SQLException
	{
		Connection con = GetConnection();
		String query = "INSERT INTO capturas(id_usuario, id_especie) VALUES(" + usuario + "," + bicho + ")";
		PreparedStatement st = con.prepareStatement(query);
		st.executeUpdate();

		if (nombre != null)
		{
			query = "Select max(id_bicho) from usuarioBicho where id_usuario = " + usuario;
			st = con.prepareStatement(query);
			ResultSet rs = st.executeQuery();

			if (rs.next())
			{
				bicho = rs.getInt(1);
				query = "update usuarioBicho set nombre = \'" + nombre + "\' where usuarioBicho.id_bicho = " + bicho;
				st = con.prepareStatement(query);
				st.executeUpdate();
			}
		}
	}

	public static void altaUsuario(String nombre) throws SQLException
	{
		Connection con = GetConnection();
		String query = "Insert into usuario(nombre) values (\'" + nombre + "\')";
		PreparedStatement st = con.prepareStatement(query);
		st.executeUpdate();
	}

	public static void eliminarUsuario(int id) throws SQLException
	{
		Connection con = GetConnection();
		String query = "delete from usuario where id = " + id;
		PreparedStatement st = con.prepareStatement(query);
		st.executeUpdate();
		
	}
}
