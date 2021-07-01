import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

/*
schreibt die Werte der Tabelle formatiert in eine Textdatei, sodass man das in die Lookuptabelle reinkopieren kann
*/

public class Main {

	BufferedWriter writer;

	public static void main(String[] args) throws IOException {
		Main main = new Main();
		main.writeFile();
		System.out.println("erfolgreich!");
	}

	public void writeFile() throws IOException {
		writer = new BufferedWriter(new FileWriter("table"));
		writer.write("{");
		wurzel();
		writer.write("}");
		writer.close();
	}

	public void wurzel() throws IOException {
		for (int i = 0; i < 65536; i++) {
			float eingabe = (float) (1 + 8 * i * Math.log(2));
			float ausgabe = (float) Math.sqrt((double) eingabe);
			String str = Float.toString(ausgabe) + ",";
			if (i % 50 == 0) {
				str += "\n";
			}
			writer.write(str);
		}
		großeTabelleExponentiellEinfach();
	}

	//2. Bereich fängt bei 363409,749 an
	public void großeTabelleExponentiellEinfach() throws IOException {
		double anfang = 363408.749;
		double k = 1.00070330;
		double momentan = 0;
		for (int i = 0; i < 65535; i++) {
			momentan = anfang + Math.pow(k, i);
			double ergebnis = Math.sqrt(momentan);
			String str = Float.toString((float) ergebnis) + ",";
			if (i % 50 == 0) {
				str += "\n";
			}
			writer.write(str);
		}
		highestValueEinfach();
	}

	public void highestValueEinfach() throws IOException {
		double d = 1.0229046916162124527376386815346005188115790767083096E20;
		String str = Float.toString((float) Math.sqrt(d));
		writer.write(str);
	}
}
