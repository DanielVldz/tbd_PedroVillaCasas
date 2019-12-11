package formulario_bichos;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;

public class Dialog_renombrarUsuarios extends JDialog
{
	private static final long serialVersionUID = 1L;
	private JTextField txt_nombre;
	private JIDfield txt_id;
	private JButton btn_combate;
	private String nombre;
	private int id;
	
	public Dialog_renombrarUsuarios()
	{
		setTitle("Cambiar nombre");
		setModal(true);
		setLayout(new GridBagLayout());
		setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		setResizable(false);
		setSize(300, 90);
		setLocationRelativeTo(this.getParent());
		init();
	}

	private void init()
	{
		GridBagConstraints gbc = new GridBagConstraints();

		gbc.gridx = 0;
		gbc.gridy = 0;
		gbc.fill = GridBagConstraints.BOTH;
		add(new JLabel("ID "), gbc);

		gbc.gridy = 1;
		add(new JLabel("Nuevo nombre"), gbc);

		gbc.gridy = 3;
		gbc.gridwidth = 2;
		btn_combate = new JButton("Cambiar el nombre");
		btn_combate.addActionListener(e -> agregar());
		add(btn_combate, gbc);
		gbc.gridwidth = 1;

		gbc.gridx = 1;
		gbc.gridy = 0;
		gbc.weightx = 1.0;
		txt_id = new JIDfield();
		add(txt_id, gbc);

		gbc.gridy = 1;
		txt_nombre = new JTextField();
		add(txt_nombre, gbc);
	}

	private void agregar()
	{
		id = Integer.valueOf(txt_id.getText());
		nombre = txt_nombre.getText();
		if (nombre == null || nombre.isEmpty())
		{
			JOptionPane.showMessageDialog(this.getParent(), "El nombre no puede estar vacío", "Datos inválidos", JOptionPane.INFORMATION_MESSAGE);
		} else
		{
			try
			{
				DBUsuarios.renombrarUsuario(id, nombre);
				JOptionPane.showMessageDialog(this.getParent(), "Usuario renombrado con éxito", "Usuario creado", JOptionPane.INFORMATION_MESSAGE);
			} catch (SQLException e)
			{
				JOptionPane.showMessageDialog(this.getParent(), "Error al cambiar nombre de usuario", "Error SQL", JOptionPane.INFORMATION_MESSAGE);
				e.printStackTrace();
			}
		}
	}
}
