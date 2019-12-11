package formulario_bichos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.table.DefaultTableModel;

public class DBEspecie extends DBConexion
{
	public static especie leeEspecie(int id) throws SQLException
	{
		especie reg = new especie();
		Connection con = GetConnection();
		String Select = "SELECT * FROM especieFormulario WHERE id = " + id + "";
		PreparedStatement st = con.prepareStatement(Select);
		ResultSet rs = st.executeQuery();
		if (!rs.wasNull())
		{
			rs.next();
			reg = crearObjeto(rs);
		}
		con.close();
		return reg;
	}

	public static DefaultTableModel llenarTabla() throws SQLException
	{
		String encabezado[] = { "ID", "Especie", "Descripcion", "Tipo 1", "Tipo 2", "Evolución", "Salud base", "Ataque Normal Base", "Defensa Normal Base", "Ataque Especial Base", "Defensa Especial Base", "Velocidad base" };
		String renglon[] = new String[19];
		DefaultTableModel dtm = new DefaultTableModel(encabezado, 0);

		Connection con = GetConnection();
		String select = "SELECT * FROM especieFormulario";
		PreparedStatement st = con.prepareStatement(select);
		ResultSet rs = st.executeQuery();

		while (rs.next())
		{
			especie reg = crearObjeto(rs);
			renglon[0] = "" + reg.getId();
			renglon[1] = "" + reg.getEspecieNombre();
			renglon[2] = "" + reg.getDescripcion();
			renglon[3] = "" + reg.getTipo1();
			renglon[4] = "" + reg.getTipo2();
			renglon[5] = "" + reg.getEvolcion();
			renglon[6] = "" + reg.getSaludBase();
			renglon[7] = "" + reg.getAtaqueNormalBase();
			renglon[8] = "" + reg.getDefensaNormalBase();
			renglon[9] = "" + reg.getAtaqueEspecialBase();
			renglon[10] = "" + reg.getDefensaEspecialBase();
			renglon[11] = "" + reg.getVelocidadBase();
			dtm.addRow(renglon);
		}
		return dtm;
	}

	private static especie crearObjeto(ResultSet rs) throws SQLException
	{
		especie reg = new especie();
		reg.setId(rs.getInt(1));
		reg.setEspecieNombre(rs.getString(2));
		reg.setDescripcion(rs.getString(3));
		reg.setTipo1(rs.getString(4));
		reg.setTipo2(rs.getString(5));
		reg.setEvolcion(rs.getString(6));
		reg.setSaludBase(rs.getInt(7));
		reg.setAtaqueNormalBase(rs.getInt(8));
		reg.setDefensaNormalBase(rs.getInt(9));
		reg.setAtaqueEspecialBase(rs.getInt(10));
		reg.setDefensaEspecialBase(rs.getInt(11));
		reg.setVelocidadBase(rs.getInt(12));
		return reg;
	}

	public static int getMaxID() throws SQLException
	{
		Connection con = GetConnection();
		String select = "SELECT max(id) FROM especie";
		PreparedStatement st = con.prepareStatement(select);
		ResultSet rs = st.executeQuery();
		int Clave = 1;
		if(!rs.wasNull())
		{
			rs.next();
			Clave = rs.getInt(1)+1;
		}
		con.close();
		return Clave;
	}
}
