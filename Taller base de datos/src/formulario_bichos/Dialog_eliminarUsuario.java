package formulario_bichos;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;

public class Dialog_eliminarUsuario extends JDialog
{
	private JButton btn_eliminarr;
	private JIDfield txt_id;
	private String nombre;

	public Dialog_eliminarUsuario()
	{
		setTitle("Eliminar combate");
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
		btn_eliminarr = new JButton("Agregar usuario");
		btn_eliminarr.addActionListener(e -> eliminar());
		add(btn_eliminarr, gbc);
		gbc.gridwidth = 1;

		gbc.weightx = 1.0;
		gbc.gridx = 1;
		gbc.gridy = 0;
		txt_id = new JIDfield();
		add(txt_id, gbc);
	}

	private void eliminar()
	{
		try
		{
			int id = Integer.valueOf(txt_id.getText());
			DBUsuarios.eliminarUsuario(id);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
}
