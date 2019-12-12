package formulario_bichos;

public class Bicho
{
	private int id, nivel, experiencia, idEntrenador, idEspecie;
	private String nombre, entrenador, especie;

	Bicho()
	{

	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getNivel()
	{
		return nivel;
	}

	public void setNivel(int nivel)
	{
		this.nivel = nivel;
	}

	public int getExperiencia()
	{
		return experiencia;
	}

	public void setExperiencia(int experiencia)
	{
		this.experiencia = experiencia;
	}

	public int getIdEntrenador()
	{
		return idEntrenador;
	}

	public void setIdEntrenador(int idEntrenador)
	{
		this.idEntrenador = idEntrenador;
	}

	public int getIdEspecie()
	{
		return idEspecie;
	}

	public void setIdEspecie(int idEspecie)
	{
		this.idEspecie = idEspecie;
	}

	public String getNombre()
	{
		return nombre;
	}

	public void setNombre(String nombre)
	{
		this.nombre = nombre;
	}

	public String getEntrenador()
	{
		return entrenador;
	}

	public void setEntrenador(String entrenador)
	{
		this.entrenador = entrenador;
	}

	public String getEspecie()
	{
		return especie;
	}

	public void setEspecie(String especie)
	{
		this.especie = especie;
	}

}
