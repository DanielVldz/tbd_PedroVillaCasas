package formulario_bichos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

import javax.swing.table.DefaultTableModel;

import org.omg.PortableServer.ID_UNIQUENESS_POLICY_ID;

public class DBBichos extends DBConexion
{
	public static Bicho bucarBicho(int id) throws SQLException
	{
		Bicho b = new Bicho();
		Connection con = GetConnection();
		String query = "select bicho.id, usuarioBicho.nombre, especie.especie, especie.id, bicho.nivel, bicho.experiencia, usuario.nombre, usuario.id from usuarioBicho left join bicho on bicho.id = usuarioBicho.id_bicho left join usuario on usuario.id = usuarioBicho.id_usuario left join especie on especie.id = bicho.id_especie where bicho.id = " + id;
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		if (rs.next())
		{
			b = crearBicho(rs);
		}
		return b;
	}

	public static void insertarBicho(int id) throws SQLException
	{

		int ataque1 = 0, salud = 0, ataqueNormal = 0, ataqueEspecial = 0, defensaNormal = 0, defensaEspecial = 0,
				velocidad = 0, nivel = 0, experiencia = 0;
		int x = 0;
		char genero;
		Random r = new Random();
		x = r.nextInt(2);
		if (x == 0)
			genero = 'f';
		else
			genero = 'm';

		Connection con = GetConnection();
		String query = "SELECT TOP 1\r\n" + "		ataqueEspecie.id_ataque\r\n" + "	FROM ataqueEspecie\r\n" + "	WHERE ataqueEspecie.id_especie = " + id + "	ORDER BY newid()";
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		if (rs.next())
			ataque1 = rs.getInt(1);

		query = "	SELECT rand()*((especie.salud_maxima - especie.salud_base)+especie.salud_base) , rand()*((especie.ataque_normal_maximo - especie.ataque_normal_base) + especie.ataque_normal_base), ((especie.ataque_especial_maximo - especie.ataque_especial_base) + especie.ataque_especial_base), ((especie.defensa_normal_maxima - especie.defensa_normal_base) + especie.defensa_normal_base), ((especie.defensa_especial_maxima- especie.defensa_especial_base) + especie.defensa_especial_base), ((especie.velocidad_maxima - especie.velocidad_base) + especie.velocidad_base), rand()*(20 - 5) + 5, rand()*(500 - 50) + 50\r\n" + "	FROM especie\r\n" + "	WHERE especie.id =" + id;
		st = con.prepareStatement(query);
		rs = st.executeQuery();
		if (rs.next())
		{
			salud = rs.getInt(1);
			ataqueNormal = rs.getInt(2);
			ataqueEspecial = rs.getInt(3);
			defensaNormal = rs.getInt(4);
			defensaEspecial = rs.getInt(5);
			velocidad = rs.getInt(6);
			nivel = rs.getInt(7);
			experiencia = rs.getInt(8);
		}
		query = "INSERT INTO bicho\r\n" + "		(id_especie, id_ataque1, genero, salud, ataque_normal, ataque_especial, defensa_normal, defensa_especial, velocidad, nivel, experiencia)\r\n" + "	VALUES(" + id + ", " + ataque1 + ", \'" + genero + "\', " + salud + ", " + ataqueNormal + ", " + ataqueEspecial + ", " + defensaNormal + ", " + defensaEspecial + ", " + velocidad + ", " + nivel + ", " + experiencia + ")";
		st = con.prepareStatement(query);
		st.executeUpdate();
	}

	private static Bicho crearBicho(ResultSet rs) throws SQLException
	{
		Bicho b = new Bicho();
		b.setId(rs.getInt(1));
		b.setNombre(rs.getString(2));
		b.setEspecie(rs.getString(3));
		b.setIdEspecie(rs.getInt(4));
		b.setNivel(rs.getInt(5));
		b.setExperiencia(rs.getInt(6));
		b.setEntrenador(rs.getString(7));
		b.setIdEntrenador(rs.getInt(8));
		return b;
	}

	public static void borrarBicho(int id) throws SQLException
	{
		Connection con = GetConnection();
		String delete = "Delete from bicho where id = " + id;
		PreparedStatement st = con.prepareStatement(delete);
		st.executeUpdate();
	}

	public static void modificarBicho(int idBicho, int idUsuario, String nombre) throws SQLException
	{
		Connection con = GetConnection();
		String query = "select * from usuarioBicho where id_bicho = " + idBicho;
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		if (rs.wasNull())
		{
			query = "insert into usuarioBicho(id_bicho, id_usuario) values(" + idBicho + "," + idUsuario + ")";
			st = con.prepareStatement(query);
			st.executeUpdate();
		}

		query = "Update usuarioBicho set nombre = '" + nombre + "' where id_bicho = " + idBicho;
		st = con.prepareStatement(query);
		st.executeUpdate();
	}

	public static DefaultTableModel llenarStats(int id) throws SQLException
	{
		DefaultTableModel dtm;
		String encabezado[] = { "Salud", "Ataque normal", "Defensa normal", "Araque especial", "Defensa especial", "Velocidad" };
		String renglon[] = new String[6];
		dtm = new DefaultTableModel(encabezado, 0);
		Connection con = GetConnection();
		String query = "select salud, ataque_normal, defensa_normal, ataque_especial, defensa_especial, velocidad from bicho where id = " + id;
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		if (rs.next())
		{
			renglon[0] = "" + rs.getInt(1);
			renglon[1] = "" + rs.getInt(2);
			renglon[2] = "" + rs.getInt(3);
			renglon[3] = "" + rs.getInt(4);
			renglon[4] = "" + rs.getInt(5);
			renglon[5] = "" + rs.getInt(6);
			dtm.addRow(renglon);
		}
		return dtm;
	}

	public static int minBicho() throws SQLException
	{
		int id = 0;
		Connection con = GetConnection();
		String query = "select min(id) from bicho";
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();

		if (rs.next())
			id = rs.getInt(1);

		return id;
	}

	public static int maxBicho() throws SQLException
	{
		int id = 0;
		Connection con = GetConnection();
		String query = "select max(id) from bicho";
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();

		if (rs.next())
			id = rs.getInt(1);

		return id;
	}
}
