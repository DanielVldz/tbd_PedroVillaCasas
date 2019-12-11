package formulario_bichos;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.microsoft.sqlserver.jdbc.SQLServerException;

public class DBCombate extends DBConexion
{
	public static Combate buscarCombate(int id) throws SQLException
	{
		Combate reg = new Combate();
		Connection con = GetConnection();
		String query = "SELECT combate.id_combate, e1.id, e1.nombre,e2.id, e2.nombre, ganador.nombre FROM combate LEFT JOIN usuario e1 ON e1.id = combate.id_entrenador1 LEFT JOIN usuario e2 ON e2.id = combate.id_entrenador2 LEFT JOIN usuario ganador ON ganador.id = combate.id_ganador WHERE combate.id_combate = " + id;
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		if (!rs.wasNull())
		{
			rs.next();
			reg = crearObjeto(rs);
		}
		con.close();
		return reg;
	}

	private static Combate crearObjeto(ResultSet rs) throws SQLException
	{
		Combate combate = new Combate();
		combate.setId(rs.getInt(1));
		combate.setId_entrenador1(rs.getInt(2));
		combate.setEntrenador1(rs.getString(3));
		combate.setId_entrenador2(rs.getInt(4));
		combate.setEntrenador2(rs.getString(5));
		combate.setGanador(rs.getString(6));
		return combate;
	}

	public static String[] listaBichos(int id) throws SQLException
	{
		int i = 0;
		String bichos[];
		Connection con = GetConnection();
		String query = "select bicho.id, usuarioBicho.nombre, especie.especie from usuarioBicho\r\n" + "left join bicho on bicho.id = usuarioBicho.id_bicho\r\n" + "left join especie on especie.id = bicho.id_especie\r\n" + "where usuarioBicho.id_usuario = " + id;
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();

		String max = "Select count(*) from usuarioBicho where id_usuario = " + id;
		PreparedStatement aux = con.prepareStatement(max);
		ResultSet rsaux = aux.executeQuery();
		if (rsaux.next())
			i = rsaux.getInt(1);

		bichos = new String[i];
		i = 0;
		while (rs.next())
		{
			String auxS = rs.getString(2);
			if (auxS == null)
				auxS = rs.getString(3);
			bichos[i] = rs.getInt(1) + " - " + auxS;
			i++;
		}
		return bichos;
	}

	public static String[] listaAtaques(int id) throws SQLException
	{
		int i = 0;
		String ataques[];
		Connection con = GetConnection();
		String queryAtaques = "select ataque.id, ataque.nombre from bicho " + "left join ataque on ataque.id = bicho.id_ataque1 or ataque.id = bicho.id_ataque2 or ataque.id = bicho.id_ataque3 or ataque.id = bicho.id_ataque4 where bicho.id = " + id;
		String queryConteo = "select count(*) from bicho left join ataque on ataque.id = bicho.id_ataque1 or ataque.id = bicho.id_ataque2 or ataque.id = bicho.id_ataque3 or ataque.id = bicho.id_ataque4 where bicho.id = " + id;
		PreparedStatement stConteo = con.prepareStatement(queryConteo);
		ResultSet rs = stConteo.executeQuery();

		if (rs.next())
		{
			i = rs.getInt(1);
		}

		ataques = new String[i];
		i = 0;

		PreparedStatement stAtaques = con.prepareStatement(queryAtaques);
		rs = stAtaques.executeQuery();

		while (rs.next())
		{
			ataques[i] = rs.getInt(1) + " - " + rs.getString(2);
			i++;
		}

		return ataques;
	}

	public static String[] lsitaRondas(int id) throws SQLException
	{
		int i = 0;
		CallableStatement cst;
		String rondas[];
		Connection con = GetConnection();
		String query = "SELECT COUNT(*) FROM ronda WHERE id_combate = " + id;
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		rs.next();
		i = rs.getInt(1);

		rondas = new String[i];
		query = "SELECT e1.id, e1.especie, a.id, a.nombre, e2.id, e2.especie FROM ronda" + " LEFT JOIN especie e1 ON e1.id = ronda.id_atacante" + " LEFT JOIN especie e2 ON e2.id = ronda.id_atacado" + " LEFT JOIN ataque a ON a.id = ronda.id_ataque_realizado" + " WHERE ronda.id_combate = " + id;
		st = con.prepareStatement(query);
		rs = st.executeQuery();
		i = 0;
		while (rs.next())
		{
			int atacante = rs.getInt(1), atacado = rs.getInt(3), ataque = rs.getInt(5);
			cst = con.prepareCall("{? = call calculoDaño(?,?,?)}");
			cst.registerOutParameter(1, java.sql.Types.INTEGER);
			cst.setInt(2, atacante);
			cst.setInt(3, atacado);
			cst.setInt(4, ataque);
			cst.setEscapeProcessing(true);
			cst.execute();
			rondas[i] = rs.getString(2) + " usó " + rs.getString(4) + " con " + rs.getString(6) + ": " + cst.getInt(1) + " de daño";
			i++;
		}
		return rondas;
	}

	public static int getMaxID() throws SQLException
	{
		int id = 0;
		Connection con = GetConnection();
		String query = "select max(id_combate) from combate";
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();

		if (rs.next())
			id = rs.getInt(1);

		return id;
	}
	public static int getMinID() throws SQLException
	{
		int id = 0;
		Connection con = GetConnection();
		String query = "select min(id_combate) from combate";
		PreparedStatement st = con.prepareStatement(query);
		ResultSet rs = st.executeQuery();
		
		if (rs.next())
			id = rs.getInt(1);
		
		return id;
	}

	public static void crearCombate(int usuario1, int usuario2) throws SQLException
	{
		Connection con = GetConnection();
		String query = "insert into combate(id_entrenador2, id_entrenador2) values(" + usuario1 + "," + usuario2 + ")";
		PreparedStatement st = con.prepareStatement(query);
		st.executeUpdate();
	}

	public static void eliminarCombate(int id) throws SQLException
	{
		Connection con = GetConnection();
		String quey = "delete from combate where id_combate = " + id;
		PreparedStatement st = con.prepareStatement(quey);
		st.executeUpdate();
	}

	public static void cambiarGanador(int id, int ganador) throws SQLException, SQLServerException
	{
		Connection con = GetConnection();
		String query = "update combate set id_ganador = " + ganador + " where id_combate = " + id;
		PreparedStatement st = con.prepareStatement(query);
		st.executeUpdate();
	}
}
