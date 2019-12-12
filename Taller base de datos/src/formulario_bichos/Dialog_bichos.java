package formulario_bichos;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;

public class Dialog_bichos extends JDialog
{
	private static final long serialVersionUID = -2233409249803765514L;

	private JIDfield txt_idBicho, txt_idUsuario;
	private JTextField txt_nombre;
	private JButton btn_accion;

	public Dialog_bichos(int n)
	{
		setModal(true);
		setLayout(new GridBagLayout());
		setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		setSize(250, 115);
		setLocationRelativeTo(this.getParent());
		switch (n)
		{
			case 1:
				setSize(250, 80);
				initCrear();
				break;
			case 2:
				initEditar();
				break;
			case 3:
				setSize(250, 80);
				initEliminar();
				break;
		}
	}

	void initCrear()
	{
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.fill = GridBagConstraints.BOTH;
		gbc.gridx = 0;
		gbc.gridy = 0;
		add(new JLabel("Especie para crear:"), gbc);

		gbc.gridy = 1;
		gbc.gridwidth = 2;
		btn_accion = new JButton("Crear bicho");
		btn_accion.addActionListener(e -> crearBicho());
		add(btn_accion, gbc);
		gbc.gridwidth = 1;

		gbc.weightx = 1.0;
		gbc.gridx = 1;
		gbc.gridy = 0;
		txt_idBicho = new JIDfield();
		add(txt_idBicho, gbc);
	}

	void initEliminar()
	{
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.fill = GridBagConstraints.BOTH;
		gbc.gridx = 0;
		gbc.gridy = 0;
		add(new JLabel("Bicho para eliminar:"), gbc);

		gbc.gridy = 1;
		gbc.gridwidth = 2;
		btn_accion = new JButton("Eliminar bicho");
		btn_accion.addActionListener(e -> eliminarBicho());
		add(btn_accion, gbc);
		gbc.gridwidth = 1;

		gbc.weightx = 1.0;
		gbc.gridx = 1;
		gbc.gridy = 0;
		txt_idBicho = new JIDfield();
		add(txt_idBicho, gbc);
	}

	void initEditar()
	{
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.fill = GridBagConstraints.BOTH;
		gbc.gridx = 0;
		gbc.gridy = 0;
		add(new JLabel("ID del bicho:"), gbc);

		gbc.gridy = 1;
		add(new JLabel("ID del usuario: "), gbc);

		gbc.gridy = 2;
		add(new JLabel("Nombre para el bicho"), gbc);

		gbc.gridy = 3;
		gbc.gridwidth = 2;
		btn_accion = new JButton("Editar bicho");
		btn_accion.addActionListener(e -> editarBicho());
		add(btn_accion, gbc);
		gbc.gridwidth = 1;

		gbc.weightx = 1.0;
		gbc.gridx = 1;
		gbc.gridy = 0;
		txt_idBicho = new JIDfield();
		add(txt_idBicho, gbc);

		gbc.gridy = 1;
		txt_idUsuario = new JIDfield();
		add(txt_idUsuario, gbc);

		gbc.gridy = 2;
		txt_nombre = new JTextField();
		add(txt_nombre, gbc);

	}

	private void editarBicho()
	{
		try
		{
			DBBichos.modificarBicho(Integer.valueOf(txt_idBicho.getText()), Integer.valueOf(txt_idUsuario.getText()), txt_nombre.getText());
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se pudo actualizar el bicho");
		}
	}

	private void crearBicho()
	{
		try
		{
			DBBichos.insertarBicho(Integer.valueOf(txt_idBicho.getText()));
		} catch (SQLException e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(this.getParent(), "No se pudo crear el bicho");
		}
	}

	private void eliminarBicho()
	{
		try
		{
			DBBichos.borrarBicho(Integer.valueOf(txt_idBicho.getText()));
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se pudo eliminar bicho");
		}
	}
}
