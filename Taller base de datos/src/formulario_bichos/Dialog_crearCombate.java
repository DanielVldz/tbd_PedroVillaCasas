package formulario_bichos;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

public class Dialog_crearCombate extends JDialog
{
	private static final long serialVersionUID = 1L;
	private JIDfield txt_entrenador1, txt_entrenador2;
	private JButton btn_combate;

	public Dialog_crearCombate()
	{
		setTitle("Agregar un combate");
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
		add(new JLabel("Usuario "), gbc);

		gbc.gridy = 1;
		add(new JLabel("Especie: "), gbc);

		gbc.gridy = 3;
		gbc.gridwidth = 2;
		btn_combate = new JButton("Comenzar el combate");
		btn_combate.addActionListener(e -> realizarCombate());
		add(btn_combate, gbc);
		gbc.gridwidth = 1;

		gbc.gridx = 1;
		gbc.gridy = 0;
		gbc.weightx = 1.0;
		txt_entrenador1 = new JIDfield();
		add(txt_entrenador1, gbc);

		gbc.gridy = 1;
		txt_entrenador2 = new JIDfield();
		add(txt_entrenador2, gbc);
	}

	private void realizarCombate()
	{
		int entrenador1, entrenador2;
		try
		{
			entrenador1 = Integer.valueOf(txt_entrenador1.getText());
			entrenador2= Integer.valueOf(txt_entrenador2.getText());
			JOptionPane.showMessageDialog(this.getParent(), "Captura realizada con éxito");
		}
		catch(NumberFormatException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "ID usuario o ID bicho no pueden estar vacíos", "Inserción realizada", JOptionPane.OK_OPTION);
		}
	}	
}
