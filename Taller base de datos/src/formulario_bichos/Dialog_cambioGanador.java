package formulario_bichos;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import com.microsoft.sqlserver.jdbc.SQLServerException;

public class Dialog_cambioGanador extends JDialog
{
	private static final long serialVersionUID = 1L;
	private JIDfield txt_combate, txt_entrenador2;
	private JButton btn_combate;

	public Dialog_cambioGanador()
	{
		setTitle("Cambiar ganador");
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
		add(new JLabel("Combate "), gbc);

		gbc.gridy = 1;
		add(new JLabel("Nuevo ganador "), gbc);

		gbc.gridy = 3;
		gbc.gridwidth = 2;
		btn_combate = new JButton("Cambiar el ganador");
		btn_combate.addActionListener(e -> realizarCambio());
		add(btn_combate, gbc);
		gbc.gridwidth = 1;

		gbc.gridx = 1;
		gbc.gridy = 0;
		gbc.weightx = 1.0;
		txt_combate = new JIDfield();
		add(txt_combate, gbc);

		gbc.gridy = 1;
		txt_entrenador2 = new JIDfield();
		add(txt_entrenador2, gbc);
	}

	private void realizarCambio()
	{
		int idCombate, idGanador;
		try
		{
			idCombate = Integer.valueOf(txt_combate.getText());
			idGanador = Integer.valueOf(txt_entrenador2.getText());
			DBCombate.cambiarGanador(idCombate, idGanador);
			JOptionPane.showMessageDialog(this.getParent(), "Ganador cambiado con éxito");
		}catch(SQLServerException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "El usuario no participó en el combate");
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se pudo realizar el cambio");
		}
	}
}
