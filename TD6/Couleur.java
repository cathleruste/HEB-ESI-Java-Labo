package java.tds.td6;

/**
 * regroupe les codes de différentes couleurs 
 */
public class Couleur{
	
	/** retourne le code couleur du noir SOUS LINUX.
	 * @return code couleur du noir
	 */
	public static String getNoir(){
		return "\033[30m";
	}

	/** retourne le code couleur du blanc SOUS LINUX.
	 * @return code couleur du blanc
	 */
	public static String getBlanc(){
		return "\033[37m";
	}

	/** retourne le code couleur du rouge SOUS LINUX.
	 * @return code couleur du rouge
	 */
	public static String getRouge(){
		return "\033[31m";
	}

	/** retourne le code couleur du jaune SOUS LINUX.
	 * @return code couleur du jaune
	 */
	public static String getJaune(){
		return "\033[33m";
	}

	/** retourne le code couleur du vert SOUS LINUX.
	 * @return code couleur du vert
	 */
	public static String getVert(){
		return "\033[32m";
	}

	/** retourne le code couleur du bleu SOUS LINUX.
	 * @return code couleur du bleu
	 */
	public static String getBleu(){
		return "\033[34m";
	}

	/** retourne le code couleur du rose SOUS LINUX.
	 * @return code couleur du rose
	 */
	public static String getRose(){
		return "\033[35m";
	}

	/** retourne le code couleur du gris SOUS LINUX.
	 * @return code couleur du gris
	 */
	public static String getGris(){
		return "\033[38m";
	}
}


