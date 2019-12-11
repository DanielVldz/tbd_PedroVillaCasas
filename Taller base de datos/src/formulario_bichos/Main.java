package formulario_bichos;

import javax.swing.SwingUtilities;

public class Main extends DBConexion
{
	public static void main(String[] args)
	{
		SwingUtilities.invokeLater(new Runnable()
		{
			@Override
			public void run()
			{
				Ventana v = new Ventana();
				v.setVisible(true);
			}
		});
	}
}
