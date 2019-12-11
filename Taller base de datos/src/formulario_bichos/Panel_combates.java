package formulario_bichos;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.JToolBar;

public class Panel_combates extends JPanel
{
	private static final long serialVersionUID = 1L;

	private Dialog_crearCombate crearCombate;
	private JButton btn_anterior, btn_siguiente, btn_buscar, btn_agregar, btn_ronda, btn_eliminar, btn_cambiarGanador;
	private JComboBox<String> combo_bicho1, combo_ataques1, combo_bicho2, combo_ataques2;
	private JLabel lbl_entrenador1, lbl_entrenador2, lbl_ganador, lbl_combate;
	private JTextPane jtp_logCombate;
	private JScrollPane scroll_log;
	private JPanel pnl_combate;
	private JToolBar jtb_encabezado;
	private JIDfield cajaID;
	private int idActual = 1;
	private boolean cambio = false;

	public Panel_combates()
	{
		setLayout(new BorderLayout());
		init();
		try
		{
			idActual = DBCombate.getMinID();
			llenarDatos(DBCombate.buscarCombate(idActual));
		} catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	private void init()
	{
		// Norte
		jtb_encabezado = new JToolBar();
		jtb_encabezado.setFloatable(false);
		this.add(jtb_encabezado, BorderLayout.NORTH);

		btn_anterior = new JButton("Combate anterior");
		btn_anterior.addActionListener(e -> combateAnterior());
		jtb_encabezado.add(btn_anterior);

		btn_siguiente = new JButton("Siguiente combate");
		btn_siguiente.addActionListener(e -> combateSiguiente());
		jtb_encabezado.add(btn_siguiente);

		jtb_encabezado.addSeparator();

		cajaID = new JIDfield();
		jtb_encabezado.add(cajaID);

		btn_buscar = new JButton("Buscar por ID");
		btn_buscar.addActionListener(e -> buscarCombate());
		jtb_encabezado.add(btn_buscar);

		jtb_encabezado.addSeparator();

		btn_eliminar = new JButton("Eliminar un combate");
		btn_eliminar.addActionListener(e -> eliminarCombate());
		jtb_encabezado.add(btn_eliminar);
		jtb_encabezado.addSeparator();

		btn_cambiarGanador = new JButton("Cambiar el ganador");
		btn_cambiarGanador.addActionListener(e -> cambioGanador());
		jtb_encabezado.add(btn_cambiarGanador);
		jtb_encabezado.addSeparator();

		btn_agregar = new JButton("Iniciar nuevo combate");
		btn_agregar.addActionListener(e -> agregarCombate());
		jtb_encabezado.add(btn_agregar);

		// Sur
		jtp_logCombate = new JTextPane();
		scroll_log = new JScrollPane(jtp_logCombate);
		scroll_log.setPreferredSize(new Dimension(10, 100));
		add(scroll_log, BorderLayout.SOUTH);

		// Centro
		pnl_combate = new JPanel(new GridBagLayout());
		GridBagConstraints gbc = new GridBagConstraints();

		gbc.gridx = 1;
		gbc.gridy = 1;
		gbc.weightx = 1.0;
		pnl_combate.add(new JLabel("ENTRENADOR 1"), gbc);

		lbl_entrenador1 = new JLabel("ENTRENADOR 1");
		gbc.gridy = 2;
		pnl_combate.add(lbl_entrenador1, gbc);

		gbc.gridy = 3;
		gbc.weighty = 1.0;
		pnl_combate.add(new JLabel("Bicho 1"), gbc);

		gbc.gridy = 4;

		combo_bicho1 = new JComboBox<String>();
		combo_bicho1.addActionListener(e -> cargarAtaques(0));
		pnl_combate.add(combo_bicho1, gbc);

		gbc.gridy = 6;
		pnl_combate.add(new JLabel("Ataque"), gbc);

		gbc.gridy = 7;
		combo_ataques1 = new JComboBox<String>();
		pnl_combate.add(combo_ataques1, gbc);

		gbc.gridx = 2;
		gbc.gridy = 3;
		lbl_combate = new JLabel("Combate " + idActual);
		pnl_combate.add(lbl_combate, gbc);

		gbc.gridy = 4;
		lbl_ganador = new JLabel("Ganador: ");
		pnl_combate.add(lbl_ganador, gbc);

		gbc.gridy = 5;
		btn_ronda = new JButton("Iniciar ronda");
		btn_ronda.addActionListener(e -> realizarRonda());
		pnl_combate.add(btn_ronda, gbc);

		gbc.gridx = 3;
		gbc.gridy = 1;
		gbc.weightx = 1.0;

		pnl_combate.add(new JLabel("ENTRENADOR 2"), gbc);

		lbl_entrenador2 = new JLabel("ENTRENADOR 2");
		gbc.gridy = 2;
		pnl_combate.add(lbl_entrenador2, gbc);

		gbc.gridy = 3;
		pnl_combate.add(new JLabel("Bicho 2"), gbc);

		gbc.gridy = 4;
		combo_bicho2 = new JComboBox<String>();
		combo_bicho2.addActionListener(e -> cargarAtaques(1));
		pnl_combate.add(combo_bicho2, gbc);

		gbc.gridy = 6;
		pnl_combate.add(new JLabel("Ataque"), gbc);

		gbc.gridy = 7;
		combo_ataques2 = new JComboBox<String>();
		pnl_combate.add(combo_ataques2, gbc);

		this.add(pnl_combate, BorderLayout.CENTER);
	}

	private void cambioGanador()
	{
		Dialog_cambioGanador d = new Dialog_cambioGanador();
		d.setVisible(true);
		try
		{
			llenarDatos(DBCombate.buscarCombate(idActual));
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "Error al actualizar los datos de la interfaz");
		}
	}

	private void eliminarCombate()
	{
		try
		{
			Dialog_eliminarCombate e = new Dialog_eliminarCombate();
			e.setVisible(true);
			idActual = DBCombate.getMaxID();
			llenarDatos(DBCombate.buscarCombate(idActual));
		} catch (SQLException e1)
		{
			e1.printStackTrace();
		}
	}

	private void agregarCombate()
	{
		crearCombate = new Dialog_crearCombate();
		crearCombate.setVisible(true);
	}

	private void cargarAtaques(int n)
	{
		String ataques[];
		String aux;
		int id;
		if (!cambio)
		{
			if (n == 0)
			{
				try
				{
					combo_ataques1.removeAllItems();
					aux = (combo_bicho1.getSelectedItem().toString().split(" "))[0];
					id = Integer.valueOf(aux);
					ataques = DBCombate.listaAtaques(id);
					for (String s : ataques)
					{
						combo_ataques1.addItem(s);
					}
				} catch (Exception e)
				{
					JOptionPane.showMessageDialog(this.getParent(), "No se pudieron cargar ataques del bicho 1");
				}
			} else
			{
				combo_ataques2.removeAllItems();
				aux = (combo_bicho2.getSelectedItem().toString().split(" "))[0];
				id = Integer.valueOf(aux);
				try
				{
					ataques = DBCombate.listaAtaques(id);
					for (String s : ataques)
					{
						combo_ataques2.addItem(s);
					}
				} catch (Exception e)
				{
					JOptionPane.showMessageDialog(this.getParent(), "No se pudieron cargar ataques del bicho 2");
				}

			}
		}
	}

	private void combateSiguiente()
	{
		try
		{
			idActual++;
			llenarDatos(DBCombate.buscarCombate(idActual));
		} catch (Exception e)
		{
			idActual = 0;
		}
	}

	private void buscarCombate()
	{
		try
		{
			llenarDatos(DBCombate.buscarCombate(Integer.valueOf(cajaID.getText())));
		} catch (Exception e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se encontró combate con el ID: " + cajaID.getText());
		}
	}

	private void combateAnterior()
	{
		try
		{
			if (idActual == 1)
				idActual = DBCombate.getMaxID();
			Combate c = DBCombate.buscarCombate((idActual - 1));
			llenarDatos(c);
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se pudo cargar el combate anterior", "Error", JOptionPane.INFORMATION_MESSAGE);
		}
	}

	private void realizarRonda()
	{

	}

	private void llenarDatos(Combate c) throws SQLException
	{
		String log[], resultadoRonda = "";
		String bichos[];
		String ganador;

		idActual = c.getId();
		lbl_entrenador1.setText(c.getId_entrenador1() + " - " + c.getEntrenador1());
		lbl_entrenador2.setText(c.getId_entrenador2() + " - " + c.getEntrenador2());

		lbl_combate.setText("Combate " + idActual);
		
		ganador = c.getGanador();
		if (!(ganador == null))
			lbl_ganador.setText("Ganador: " + ganador);

		log = DBCombate.lsitaRondas(idActual);
		for (String s : log)
		{
			resultadoRonda += s + "\n";
		}
		jtp_logCombate.setText(resultadoRonda);

		cambio = true;

		combo_bicho1.removeAllItems();
		bichos = DBCombate.listaBichos(c.getId_entrenador1());
		for (String s : bichos)
			combo_bicho1.addItem(s);

		combo_bicho2.removeAllItems();
		bichos = DBCombate.listaBichos(c.getId_entrenador2());
		for (String s : bichos)
			combo_bicho2.addItem(s);

		cambio = false;

		cargarAtaques(0);
		cargarAtaques(1);

	}
}
