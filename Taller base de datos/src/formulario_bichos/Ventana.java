package formulario_bichos;

import java.awt.BorderLayout;
import java.awt.Dimension;
import javax.swing.JFrame;
import javax.swing.JTabbedPane;
import javax.swing.UIManager;

public class Ventana extends JFrame
{
	private static final long serialVersionUID = 1558761861430485527L;
	private JTabbedPane jtb_pestañas;
	private Panel_especies especies;
	private Panel_usuarios usuarios;
	private Panel_combates combates;
	
	public Ventana()
	{
		super("PokeMongo");
		try {
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		}catch(Exception e)
		{}
		setLayout(new BorderLayout());
		setSize(720,550);
		setMinimumSize(new Dimension(720, 570));
		setLocationRelativeTo(null);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		inicializar();

	}

	private void inicializar()
	{
		jtb_pestañas = new JTabbedPane();
		add(jtb_pestañas, BorderLayout.CENTER);
		
		especies = new Panel_especies();
		jtb_pestañas.add(especies, "Especies");
		
		usuarios = new Panel_usuarios();
		jtb_pestañas.add(usuarios, "Usuarios");
	
		combates = new Panel_combates();
		jtb_pestañas.add(combates, "Combates");
		
	}
}
