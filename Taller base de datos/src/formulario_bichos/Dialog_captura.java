package formulario_bichos;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;

public class Dialog_captura extends JDialog
{
	private static final long serialVersionUID = 1L;
	private JIDfield txt_usuario, txt_especie;
	private JTextField txt_nombre;
	private JButton btn_capturar;

	public Dialog_captura()
	{
		setTitle("Agregar un bicho");
		setModal(true);
		setLayout(new GridBagLayout());
		setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		setResizable(false);
		setSize(300, 110);
		setLocationRelativeTo(this.getParent());
		init();
	}

	private void init()
	{
		GridBagConstraints gbc = new GridBagConstraints();

		gbc.gridx = 0;
		gbc.gridy = 0;
		gbc.fill = GridBagConstraints.BOTH;
		add(new JLabel("Usuario "), gbc);

		gbc.gridy = 1;
		add(new JLabel("Especie: "), gbc);

		gbc.gridy = 2;
		add(new JLabel("Agregue un nombre: "), gbc);
		gbc.ipadx = 0;

		gbc.gridy = 3;
		gbc.gridwidth = 2;
		btn_capturar = new JButton("Capturar al bicho");
		btn_capturar.addActionListener(e -> realizarCaptura());
		add(btn_capturar, gbc);
		gbc.gridwidth = 1;

		gbc.gridx = 1;
		gbc.gridy = 0;
		gbc.weightx = 1.0;
		txt_usuario = new JIDfield();
		add(txt_usuario, gbc);

		gbc.gridy = 1;
		txt_especie = new JIDfield();
		add(txt_especie, gbc);

		gbc.gridy = 2;
		txt_nombre = new JTextField();
		add(txt_nombre, gbc);
	}

	private void realizarCaptura()
	{
		int idUsuario, idEspecie;
		String nombre;
		try
		{
			idUsuario = Integer.valueOf(txt_usuario.getText());
			idEspecie= Integer.valueOf(txt_especie.getText());
			nombre = txt_nombre.getText();
			DBUsuarios.capturarBicho(idUsuario, idEspecie, nombre);
			JOptionPane.showMessageDialog(this.getParent(), "Captura realizada con éxito");
		}
		catch(NumberFormatException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "ID usuario o ID bicho no pueden estar vacíos", "Inserción realizada", JOptionPane.OK_OPTION);
		}
		catch(SQLException e1)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se pudo registrar la captura");
		}
	}	
}
