package td.td6;

/**
 * regroupe les codes de différentes couleurs sous Linux.
 */
public class Couleur{

	/** retourne le code couleur par défaut SOUS LINUX, c-à-d le blanc.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getDefault() + "texte à afficher");
	 * @return code couleur du blanc
	 */
	public static String getDefault(){
		return getBlanc();
	}


	/** retourne le code couleur du noir SOUS LINUX.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getBlack() + "texte à afficher" +
	 * Couleur.getDefault());
	 * @return code couleur du noir
	 */
	public static String getBlack(){
		return "\033[30m";
	}

	/** retourne le code couleur du blanc SOUS LINUX.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getWhite() + "texte à afficher" +
	 * Couleur.getDefault());
	 * @return code couleur du blanc
	 */
	public static String getWhite(){
		return "\033[37m";
	}

	/** retourne le code couleur du rouge SOUS LINUX.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getRed() + "texte à afficher" +
	 * Couleur.getDefault());
	 * @return code couleur du rouge
	 */
	public static String getRed(){
		return "\033[31m";
	}

	/** retourne le code couleur du jaune SOUS LINUX.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getYellow() + "texte à afficher" +
	 * Couleur.getDefault());
	 * @return code couleur du jaune
	 */
	public static String getYellow(){
		return "\033[33m";
	}

	/** retourne le code couleur du vert SOUS LINUX.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getGreen() + "texte à afficher" +
	 * Couleur.getDefault());
	 * @return code couleur du vert
	 */
	public static String getGreen(){
		return "\033[32m";
	}

	/** retourne le code couleur du bleu SOUS LINUX.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getBlue() + "texte à afficher" +
	 * Couleur.getDefault());
	 * @return code couleur du bleu
	 */
	public static String getBlue(){
		return "\033[34m";
	}

	/** retourne le code couleur du rose SOUS LINUX.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getPink() + "texte à afficher" +
	 * Couleur.getDefault());
	 * @return code couleur du rose
	 */
	public static String getPink(){
		return "\033[35m";
	}

	/** retourne le code couleur du gris SOUS LINUX.
	 * On l'utilise dans un System.out.println() sous la forme :
	 * System.out.println(Couleur.getGrey() + "texte à afficher" +
	 * Couleur.getDefault());
	 * @return code couleur du gris
	 */
	public static String getGrey(){
		return "\033[38m";
	}
}


