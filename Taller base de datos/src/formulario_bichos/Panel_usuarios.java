package formulario_bichos;

import java.awt.BorderLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.sql.SQLException;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JToolBar;
import javax.swing.table.DefaultTableModel;

public class Panel_usuarios extends JPanel
{
	private static final long serialVersionUID = 1L;

	private JToolBar jtb;
	private JPanel pnl_centro;
	private JButton btn_anterior, btn_bucar, btn_siguiente, btn_agregar, btn_capturar, btn_renombrar, btn_eliminar;
	private Dialog_captura capturar;
	private Dialog_altaUsuario crearUsuario;
	private JLabel lbl_id, lbl_nombre, lvl_victorias;
	private JComboBox<String> usuarios;
	private JIDfield cajaID;
	private JTable tabla_bichos;
	private DefaultTableModel dtm;
	private JScrollPane scroll_tabla;
	private int idActual = 1;

	public Panel_usuarios()
	{
		setLayout(new BorderLayout());
		init();
		llenarCombo();
		try
		{
			llenarDatos(DBUsuarios.getUsuraioPorID(idActual));
		} catch (SQLException e)
		{
		}
	}

	private void init()
	{
		jtb = new JToolBar();
		add(jtb, BorderLayout.NORTH);

		btn_eliminar = new JButton("Eliminar usuario");
		btn_eliminar.addActionListener(e -> eliminarUsuario());
		jtb.add(btn_eliminar);
		
		btn_renombrar = new JButton("Renombrar usuario");
		btn_renombrar.addActionListener(e -> renombrarUsuario());
		jtb.add(btn_renombrar);

		// centro
		pnl_centro = new JPanel(new GridBagLayout());
		add(pnl_centro, BorderLayout.CENTER);

		GridBagConstraints gbc = new GridBagConstraints();

		gbc.fill = GridBagConstraints.NONE;
		btn_anterior = new JButton("Usuario anterior");
		btn_anterior.addActionListener(e -> usuarioAnterior());
		gbc.gridx = 1;
		gbc.gridy = 1;
		gbc.gridwidth = 3;
		pnl_centro.add(btn_anterior, gbc);

		gbc.gridwidth = 2;
		gbc.gridx = 4;
		pnl_centro.add(new JLabel(), gbc);

		gbc.weightx = 1.0;
		gbc.fill = GridBagConstraints.HORIZONTAL;
		gbc.anchor = GridBagConstraints.WEST;
		cajaID = new JIDfield();
		gbc.gridwidth = 3;
		gbc.gridx = 6;
		pnl_centro.add(cajaID, gbc);
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.fill = GridBagConstraints.NONE;

		btn_bucar = new JButton("Buscar por ID");
		btn_bucar.addActionListener(e -> buscarUsuario());
		gbc.gridx = 9;
		gbc.weightx = 0.0;
		pnl_centro.add(btn_bucar, gbc);

		usuarios = new JComboBox<>();
		usuarios.addActionListener(e -> seleccionarCombo());
		gbc.gridx = 14;
		gbc.gridwidth = 4;
		pnl_centro.add(usuarios, gbc);

		btn_siguiente = new JButton("Siguiente usuario");
		btn_siguiente.addActionListener(e -> siguienteUsuario());
		gbc.gridx = 18;
		gbc.gridwidth = 3;
		pnl_centro.add(btn_siguiente, gbc);

		gbc.gridx = 23;
		pnl_centro.add(new JLabel(), gbc);

		gbc.gridx = 0;
		gbc.gridy = 1;
		pnl_centro.add(new JLabel(), gbc);

		gbc.gridx = 0;
		gbc.gridy = 2;
		pnl_centro.add(new JLabel(), gbc);

		gbc.gridx = 0;
		gbc.gridy = 3;
		gbc.gridwidth = 2;
		pnl_centro.add(new JLabel(), gbc);

		lbl_id = new JLabel("ID");
		gbc.anchor = GridBagConstraints.WEST;
		gbc.gridx = 2;
		gbc.gridwidth = 4;
		pnl_centro.add(lbl_id, gbc);

		gbc.gridx = 6;
		gbc.gridwidth = 3;
		pnl_centro.add(new JLabel(), gbc);

		gbc.gridx = 0;
		gbc.gridy = 4;
		gbc.gridwidth = 2;
		pnl_centro.add(new JLabel(), gbc);

		gbc.gridx = 0;
		gbc.gridy = 5;
		gbc.gridwidth = 2;
		pnl_centro.add(new JLabel(), gbc);

		lbl_nombre = new JLabel("Nombre del usuario");
		gbc.gridx = 2;
		gbc.gridy = 5;
		gbc.gridwidth = 4;
		pnl_centro.add(lbl_nombre, gbc);

		gbc.gridx = 0;
		gbc.gridy = 6;
		gbc.gridwidth = 2;
		pnl_centro.add(new JLabel(), gbc);

		gbc.gridx = 0;
		gbc.gridy = 7;
		gbc.gridwidth = 2;
		pnl_centro.add(new JLabel(), gbc);

		lvl_victorias = new JLabel("Número de victorias");
		gbc.gridx = 2;
		gbc.gridy = 7;
		gbc.gridwidth = 4;
		pnl_centro.add(lvl_victorias, gbc);

		gbc.gridx = 0;
		gbc.gridy = 8;
		gbc.gridwidth = 2;
		pnl_centro.add(new JLabel(), gbc);
		gbc.anchor = GridBagConstraints.CENTER;

		btn_agregar = new JButton("Agregar usuario");
		btn_agregar.addActionListener(e -> agregarUsuario());
		gbc.gridx = 1;
		gbc.gridy = 9;
		gbc.gridwidth = 3;
		pnl_centro.add(btn_agregar, gbc);

		btn_capturar = new JButton("Capturar un bicho");
		btn_capturar.addActionListener(e -> realizarCaptura());
		gbc.gridx = 20;
		pnl_centro.add(btn_capturar, gbc);

		tabla_bichos = new JTable();
		scroll_tabla = new JScrollPane(tabla_bichos);
		gbc.fill = GridBagConstraints.BOTH;
		gbc.gridx = 6;
		gbc.gridy = 3;
		gbc.gridwidth = 20;
		gbc.gridheight = 6;
		pnl_centro.add(scroll_tabla, gbc);
	}

	private Object renombrarUsuario()
	{
		// TODO Auto-generated method stub
		return null;
	}

	private void eliminarUsuario()
	{
		Dialog_eliminarUsuario us = new Dialog_eliminarUsuario();
		us.setVisible(true);
		try
		{
			llenarDatos(DBUsuarios.getUsuraioPorID(DBUsuarios.minUsuario()));
		} catch (SQLException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void agregarUsuario()
	{
		crearUsuario = new Dialog_altaUsuario();
		crearUsuario.setVisible(true);
	}

	private void realizarCaptura()
	{
		capturar = new Dialog_captura();
		capturar.setVisible(true);
		try
		{
			llenarDatos(DBUsuarios.getUsuraioPorID(idActual));
		} catch (Exception e)
		{
		}
	}

	private void siguienteUsuario()
	{
		try
		{
			llenarDatos(DBUsuarios.getUsuraioPorID(idActual + 1));
		} catch (Exception e)
		{
			idActual = 0;
			siguienteUsuario();
		}
	}

	private void seleccionarCombo()
	{
		try
		{
			llenarDatos(DBUsuarios.getUsuraioPorID(Integer.valueOf((String) usuarios.getSelectedItem())));
		} catch (Exception e)
		{
			e.printStackTrace();
			JOptionPane.showMessageDialog(this.getParent(), "Error al cargar usuario", "Error", JOptionPane.INFORMATION_MESSAGE);
		}
	}

	private void buscarUsuario()
	{
		try
		{
			Usuario usr = DBUsuarios.getUsuraioPorID(Integer.valueOf(cajaID.getText()));
			llenarDatos(usr);
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "No se encontró usuario con ID " + cajaID.getText(), "Error", JOptionPane.INFORMATION_MESSAGE);
			e.printStackTrace();
		}
	}

	private void usuarioAnterior()
	{
		try
		{
			if (idActual == 1)
				idActual = DBUsuarios.maxUsuario() + 1;
			llenarDatos(DBUsuarios.getUsuraioPorID(idActual - 1));
		} catch (Exception e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "Error al cargar usuario", "Error", JOptionPane.INFORMATION_MESSAGE);
			e.printStackTrace();
		}
	}

	private void llenarCombo()
	{
		String datos[];
		try
		{
			datos = DBUsuarios.listaUsuarios();
			for (String s : datos)
			{
				usuarios.addItem(s);
			}
		} catch (SQLException e)
		{
			JOptionPane.showMessageDialog(this.getParent(), "Error al llenar lista", "Error", JOptionPane.INFORMATION_MESSAGE);
			e.printStackTrace();
		}
	}

	private void llenarDatos(Usuario usr) throws SQLException
	{
		idActual = usr.getId();
		lbl_id.setText("ID: " + idActual);
		lbl_nombre.setText("Nombre: " + usr.getNombre());
		lvl_victorias.setText("Combates ganados: " + usr.getCombatesGanados());
		dtm = DBUsuarios.bichosUsuario(idActual);
		tabla_bichos.setModel(dtm);
	}
}
