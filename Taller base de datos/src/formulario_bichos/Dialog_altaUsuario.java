package formulario_bichos;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JTextField;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

public class Dialog_altaUsuario extends JDialog
{
	private JButton btn_agregar;
	private JTextField txt_nombre;
	private String nombre;

	public Dialog_altaUsuario()
	{
		setTitle("Alta de usuario");
		setLayout(new GridBagLayout());
		setSize(300, 70);
		setResizable(false);
		setLocationRelativeTo(this.getParent());
		setModal(true);
		setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		init();
	}

	private void init()
	{
		GridBagConstraints gbc = new GridBagConstraints();

		gbc.gridx = 0;
		gbc.gridy = 0;
		add(new JLabel("Nombre para el usuario"), gbc);

		gbc.fill = GridBagConstraints.BOTH;
		gbc.gridy = 1;
		gbc.gridwidth = 2;
		btn_agregar = new JButton("Agregar usuario");
		btn_agregar.addActionListener(e -> agregar());
		add(btn_agregar, gbc);
		gbc.gridwidth = 1;

		gbc.weightx = 1.0;
		gbc.gridx = 1;
		gbc.gridy = 0;
		txt_nombre = new JTextField();
		add(txt_nombre, gbc);
	}

	private void agregar()
	{
		nombre = txt_nombre.getText();
		if (nombre == null || nombre.isEmpty())
		{
			JOptionPane.showMessageDialog(this.getParent(), "El nombre no puede estar vacío", "Datos inválidos", JOptionPane.INFORMATION_MESSAGE);
		} else
		{
			try
			{
				DBUsuarios.altaUsuario(nombre);
				JOptionPane.showMessageDialog(this.getParent(), "Usuario agregado con éxito", "Usuario creado", JOptionPane.INFORMATION_MESSAGE);
			} catch (SQLException e)
			{
				JOptionPane.showMessageDialog(this.getParent(), "Error al crear usuario", "Error SQL", JOptionPane.INFORMATION_MESSAGE);
				e.printStackTrace();
			}
		}
	}
}
