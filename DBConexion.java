package formulario_bichos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.swing.JOptionPane;

public class DBConexion
{

	@SuppressWarnings("finally")
	public static Connection GetConnection()
	{
		Connection conexion = null;
		try
		{
			String usuario = "formularioBichos", contraseña = "pokemongo", db = "bichos";
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			conexion = DriverManager.getConnection("jdbc:sqlserver://localhost;databaseName="+db, usuario, contraseña);
		} catch (ClassNotFoundException ex)
		{
			JOptionPane.showMessageDialog(null, ex, "Error con la clase del driver de MySQL" + ex.getMessage(), JOptionPane.ERROR_MESSAGE);
			conexion = null;
		} catch (SQLException ex)
		{
			JOptionPane.showMessageDialog(null, ex, "Error en la Conexión con la BD" + ex.getMessage(), JOptionPane.ERROR_MESSAGE);
			ex.printStackTrace();
			conexion = null;
		} catch (Exception ex)
		{
			JOptionPane.showMessageDialog(null, ex, "Error del programa" + ex.getMessage(), JOptionPane.ERROR_MESSAGE);
			conexion = null;
		} finally
		{
			return conexion;
		}
	}
}
