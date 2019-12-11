package formulario_bichos;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextPane;

public class Panel_especies extends JPanel
{
	private static final long serialVersionUID = 1L;
	private JButton btn_siguiente, btn_anterior, btn_buscarID;
	private JTextPane txt_descripcion;
	private JIDfield cajaID;
	private JLabel lbl_especie, lbl_evolucion, lbl_tipo1, lbl_tipo2, lbl_salud, lbl_ataque, lbl_defensa,
			lbl_ataqueEspecial, lbl_defensaEspecial, lbl_velocidad;
	private JScrollPane scrolltxt;
	private int idActual = 1;

	public Panel_especies()
	{

		setLayout(new GridBagLayout());
		init();
		try
		{
			actualizarDatos(DBEspecie.leeEspecie(idActual));
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se pudo cargar el primer bicho", "Error", JOptionPane.INFORMATION_MESSAGE);
		}
	}

	private void init()
	{
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.gridx = 0;
		gbc.gridy = 0;
		gbc.gridwidth = 3;

		btn_anterior = new JButton("Especie Anterior");
		btn_anterior.addActionListener(e -> especieAnterior());
		add(btn_anterior, gbc);

		gbc.gridx = 4;
		gbc.gridwidth = 1;
		add(new JLabel(), gbc);

		cajaID = new JIDfield();
		cajaID.setToolTipText("Ingresa un ID");
		gbc.fill = GridBagConstraints.BOTH;
		gbc.gridx = 6;
		gbc.gridwidth = 2;
		add(cajaID, gbc);
		gbc.fill = GridBagConstraints.NONE;

		gbc.gridwidth = 1;
		btn_buscarID = new JButton("Buscar especie por ID");
		btn_buscarID.addActionListener(e -> buscarID());
		gbc.gridx = 5;
		add(btn_buscarID, gbc);
		gbc.anchor = GridBagConstraints.CENTER;

		gbc.gridwidth = 2;
		gbc.gridx = 10;
		btn_siguiente = new JButton("SIGUIENTE ESPECIE");
		btn_siguiente.addActionListener(e -> siguienteEspecie());
		add(btn_siguiente, gbc);

		gbc.gridx = 1;
		gbc.gridy = 1;
		gbc.gridwidth = 4;
		lbl_especie = new JLabel("ESPCIE ACTUAL");
		add(lbl_especie, gbc);

		gbc.gridx = 5;
		gbc.gridwidth = 1;
		lbl_tipo1 = new JLabel("TIPO 1");
		add(lbl_tipo1, gbc);

		gbc.gridx = 6;
		gbc.gridwidth = 1;
		add(new JLabel(), gbc);
		gbc.gridwidth = 1;

		gbc.gridx = 7;
		gbc.gridwidth = 1;
		lbl_tipo2 = new JLabel("TIPO 2");
		add(lbl_tipo2, gbc);

		gbc.gridx = 8;
		gbc.gridwidth = 1;
		add(new JLabel(), gbc);
		gbc.gridwidth = 1;

		gbc.gridx = 9;
		gbc.gridwidth = 1;
		add(new JLabel(), gbc);
		gbc.gridwidth = 1;

		gbc.gridx = 10;
		add(new JLabel(), gbc);
		gbc.gridwidth = 1;

		gbc.gridy = 2;
		gbc.gridx = 1;
		lbl_evolucion = new JLabel("EVOLUCIÓN");
		add(lbl_evolucion, gbc);

		gbc.gridy = 4;
		gbc.gridwidth = 8;
		gbc.gridheight = 7;
		gbc.weightx = 1.0;
		gbc.weighty = 1.0;
		gbc.fill = GridBagConstraints.BOTH;
		txt_descripcion = new JTextPane();
		scrolltxt = new JScrollPane(txt_descripcion);
		add(scrolltxt, gbc);
		gbc.weightx = 0.0;
		gbc.weighty = 0.0;
		gbc.fill = GridBagConstraints.NONE;

		gbc.anchor = GridBagConstraints.WEST;
		gbc.gridheight = 1;
		gbc.gridwidth = 3;
		gbc.gridx = 10;
		gbc.gridy = 4;
		lbl_salud = new JLabel("SALUD DEL BICHO");
		add(lbl_salud, gbc);

		gbc.gridy = 5;
		lbl_ataque = new JLabel("ATAQUE DEL BICHO");
		add(lbl_ataque, gbc);

		gbc.gridy = 6;
		lbl_defensa = new JLabel("DEFENSA NORMAL");
		add(lbl_defensa, gbc);

		gbc.gridy = 7;
		lbl_ataqueEspecial = new JLabel("ATAQUE ESPECIAL");
		add(lbl_ataqueEspecial, gbc);

		gbc.gridy = 8;
		lbl_defensaEspecial = new JLabel("DEFENSA ESPECIAL");
		add(lbl_defensaEspecial, gbc);

		gbc.gridy = 9;
		lbl_velocidad = new JLabel("VELOCIDAD");
		add(lbl_velocidad, gbc);
		gbc.anchor = GridBagConstraints.CENTER;

		gbc.gridy = 10;
		add(new JLabel(), gbc);
		gbc.gridy = 11;
		add(new JLabel(), gbc);
		gbc.gridy = 12;
		add(new JLabel(), gbc);
		gbc.gridy = 13;
		add(new JLabel(), gbc);

	}

	private void siguienteEspecie()
	{
		try
		{
			especie e = DBEspecie.leeEspecie((idActual + 1));
			actualizarDatos(e);
		} catch (SQLException e)
		{
			idActual = 0;
			siguienteEspecie();
		}
	}

	private void buscarID()
	{
		try
		{
			especie e = DBEspecie.leeEspecie(Integer.valueOf(cajaID.getText()));
			actualizarDatos(e);
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se encontró especie con ID " + cajaID.getText(), "Error", JOptionPane.INFORMATION_MESSAGE);
		}
	}

	private void especieAnterior()
	{
		try
		{
			if (idActual == 1)
				idActual = DBEspecie.getMaxID();
			especie e = DBEspecie.leeEspecie((idActual - 1));
			actualizarDatos(e);
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se pudo cargar la especie anterior", "Error", JOptionPane.INFORMATION_MESSAGE);
		}
	}

	private void actualizarDatos(especie e)
	{
		idActual = e.getId();
		lbl_especie.setText("Especie: " + e.getEspecieNombre());
		lbl_tipo1.setText("TIPO 1: " + e.getTipo1());
		lbl_tipo2.setText(e.getTipo2() == null ? "Sin tipo 2" : "TIPO 2: " + e.getTipo2());
		lbl_evolucion.setText(e.getEvolcion() == null ? "Sin evolución" : "Evolución " + e.getEvolcion());
		txt_descripcion.setText(e.getDescripcion());
		lbl_salud.setText("Salud base: " + e.getSaludBase());
		lbl_ataque.setText("Ataque base: " + e.getAtaqueNormalBase());
		lbl_defensa.setText("Defensa normal base: " + e.getDefensaNormalBase());
		lbl_ataqueEspecial.setText("Ataque especial base: " + e.getAtaqueEspecialBase());
		lbl_defensaEspecial.setText("Defensa especial base: " + e.getDefensaEspecialBase());
		lbl_velocidad.setText("Velocidad base: " + e.getVelocidadBase());
	}
}
