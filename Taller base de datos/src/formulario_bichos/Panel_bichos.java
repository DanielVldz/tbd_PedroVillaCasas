package formulario_bichos;

import java.awt.BorderLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JToolBar;
import javax.swing.table.DefaultTableModel;

public class Panel_bichos extends JPanel
{
	private JToolBar jtb_barra;
	private JButton btn_crear, btn_editar, btn_eliminar, btn_buscar, btn_siguiente, btn_anterior;
	private JIDfield txt_id;
	private JTable tbl_stats;
	private DefaultTableModel dtm;
	private JScrollPane scroll;
	private JLabel lbl_id, lbl_nombre, lbl_especie, lbl_entrenador, lbl_nivel, lbl_experiencia;
	private JPanel pnl_centro;
	private int idActual;

	public Panel_bichos()
	{
		setLayout(new BorderLayout());
		init();
		try
		{
			idActual = DBBichos.minBicho();
			llenarDatos(DBBichos.bucarBicho(idActual));
		} catch (SQLException e)
		{

		}
	}

	private void init()
	{
		jtb_barra = new JToolBar();
		jtb_barra.setFloatable(true);
		add(jtb_barra, BorderLayout.NORTH);
		jtb_barra.addSeparator();

		btn_anterior = new JButton("Bicho anterior");
		btn_anterior.addActionListener(e -> bichoAnterior());
		jtb_barra.add(btn_anterior);
		jtb_barra.addSeparator();

		txt_id = new JIDfield();
		jtb_barra.add(txt_id);
		jtb_barra.addSeparator();

		btn_buscar = new JButton("Buscar por ID");
		btn_buscar.addActionListener(e -> buscarBicho());
		jtb_barra.add(btn_buscar);
		jtb_barra.addSeparator();

		btn_editar = new JButton("Editar un bicho");
		btn_editar.addActionListener(e -> editarBicho());
		jtb_barra.add(btn_editar);
		jtb_barra.addSeparator();

		btn_eliminar = new JButton("Eliminar un bicho");
		btn_eliminar.addActionListener(e -> eliminarBicho());
		jtb_barra.add(btn_eliminar);
		jtb_barra.addSeparator();

		btn_crear = new JButton("Crear un bicho");
		btn_crear.addActionListener(e -> crearBicho());
		jtb_barra.add(btn_crear);
		jtb_barra.addSeparator();

		btn_siguiente = new JButton("Siguiente bicho");
		btn_siguiente.addActionListener(e -> siguienteBicho());
		jtb_barra.add(btn_siguiente);
		jtb_barra.addSeparator();

		// Centro
		pnl_centro = new JPanel(new GridBagLayout());
		add(pnl_centro, BorderLayout.CENTER);
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.anchor = GridBagConstraints.EAST;
		gbc.ipadx = 50;

		gbc.fill = GridBagConstraints.BOTH;
		gbc.gridx = 0;
		gbc.gridy = 0;

		lbl_id = new JLabel("ID: ");
		pnl_centro.add(lbl_id, gbc);

		gbc.gridy = 1;
		lbl_nombre = new JLabel("Nombre: ");
		pnl_centro.add(lbl_nombre, gbc);

		gbc.ipadx = 0;
		gbc.gridy = 2;
		gbc.gridwidth = 3;
		tbl_stats = new JTable();
		scroll = new JScrollPane(tbl_stats);
		pnl_centro.add(scroll, gbc);
		gbc.ipadx = 50;

		gbc.gridx = 1;
		gbc.gridy = 0;
		gbc.gridwidth = 1;
		lbl_especie = new JLabel("Especie: ");
		pnl_centro.add(lbl_especie, gbc);

		gbc.gridy = 1;
		lbl_entrenador = new JLabel("Entrenador");
		pnl_centro.add(lbl_entrenador, gbc);

		gbc.weightx = 1.0;
		gbc.gridx = 2;
		gbc.gridy = 0;
		lbl_nivel = new JLabel("Nivel: ");
		pnl_centro.add(lbl_nivel, gbc);

		gbc.gridy = 1;
		lbl_experiencia = new JLabel("Experiencia: ");
		pnl_centro.add(lbl_experiencia, gbc);
		gbc.weightx = 0.0;
	}

	private void siguienteBicho()
	{
		try
		{
			llenarDatos(DBBichos.bucarBicho(idActual + 1));
		} catch (SQLException e)
		{
			try
			{
				idActual = DBBichos.minBicho() - 1;
				siguienteBicho();
			} catch (SQLException e1)
			{

			}
		}
	}

	private void crearBicho()
	{
		Dialog_bichos d = new Dialog_bichos(1);
		d.setVisible(true);
	}

	private void eliminarBicho()
	{
		Dialog_bichos d = new Dialog_bichos(3);
		d.setVisible(true);
	}

	private void editarBicho()
	{
		Dialog_bichos d = new Dialog_bichos(2);
		d.setVisible(true);
	}

	private void buscarBicho()
	{
		try
		{
			llenarDatos(DBBichos.bucarBicho(Integer.valueOf(txt_id.getText())));
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se encontró el bicho con el ID: " + txt_id.getText());
		}
		catch(NumberFormatException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se ingresó un ID");			
		}
	}

	private void bichoAnterior()
	{
		try
		{
			llenarDatos(DBBichos.bucarBicho(idActual - 1));
		} catch (SQLException e)
		{
			try
			{
				idActual = DBBichos.maxBicho() + 1;
				bichoAnterior();
			} catch (SQLException e1)
			{

			}
		}
	}

	private void llenarDatos(Bicho b)
	{
		idActual = b.getId();
		lbl_id.setText("ID: " + b.getId());
		lbl_nombre.setText("Nombre: " + b.getNombre());
		lbl_especie.setText("Especie: " + b.getIdEspecie() + " - "+ b.getEspecie());
		lbl_entrenador.setText("Entrenador: " + b.getIdEntrenador() + " - " + b.getEntrenador());
		lbl_nivel.setText("Nivel: " + b.getNivel());
		lbl_experiencia.setText("Experiencia: " + b.getExperiencia());
		try
		{
			tbl_stats.setModel(DBBichos.llenarStats(idActual));			
		}
		catch (SQLException e)
		{}
	}
}
