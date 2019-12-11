package formulario_bichos;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JTextField;

public class JIDfield extends JTextField implements KeyListener
{
	private boolean negativo = false;

	private static final long serialVersionUID = 1L;

	public JIDfield()
	{
		addKeyListener(this);
	}

	@Override
	public void keyPressed(KeyEvent e)
	{
		// TODO Auto-generated method stub
	}

	@Override
	public void keyReleased(KeyEvent e)
	{
		// TODO Auto-generated method stub

	}

	@Override
	public void keyTyped(KeyEvent e)
	{
		if (!(e.getKeyChar() >= '0' && e.getKeyChar() <= '9'))
			e.consume();
	}
}
