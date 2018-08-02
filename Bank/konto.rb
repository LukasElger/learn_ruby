class Konto
  def initialize(konto_nr, pin)
    @konto_nr = konto_nr
    @pin = pin
    @kontostand = 0
  end

  def frage(text)
    puts text
    gets.chomp
  end

  def main_menu
    puts "\n" * 100
    print_main_menu
    auswahl = frage("Wählen Sie einen Aktion:")

    case auswahl
    when "1"
      kontostand_anzeigen
      main_menu
    when "2"
      einzahlen
      main_menu
    when "3"
      auszahlen
      main_menu
    when "4"
      pin_ändern
      main_menu
    when "5"
      puts "\n" * 100
      puts "Programm wird beendet ..."
      exit
    else
      puts "\n" * 100
      puts "Bitte wählen Sie eine Aktion zwischen 1 und 4."
      gets.chomp
      main_menu
    end
  end

  def print_main_menu
    puts "-----------------------------------------"
    puts "|Wählen sie eine der folgenden Aktionen:|"
    puts "|1. Kontostand anzeigen                 |"
    puts "|2. Geld einzahlen                      |"
    puts "|3. Geld auszahlen                      |"
    puts "|4. Pin ändern                          |"
    puts "|5. Programm beenden                    |"
    puts "-----------------------------------------"
  end

  def einzahlen
    puts "\n" * 100
    puts "Ihr aktueller Kontostand beträgt #{@kontostand}€."
    puts "Drücken Sie \"X\" um den folgenden Vorgang abzubrechen."
    betrag = frage("Geben sie den einzuzahlenden Betrag ein:")

    if betrag == "X"
      puts "\n" * 100
      puts "Einzahlung erfolgreich abgebrochen..."
      gets.chomp
      return main_menu
    elsif betrag.to_i > 0
      @kontostand += betrag.to_i
      puts "\n" * 100
      puts "Sie haben erfolgreich #{betrag}€ eingezahlt."
      puts "Ihr neuer Kontostand beträgt #{@kontostand}€."
      gets.chomp
    else
      puts "\n" * 100
      puts "Ihre Eingaben waren inkorrekt."
      puts "Bitte versuchen Sie es erneut."
      gets.chomp
      return einzahlen
    end
  end

  def auszahlen
    puts "\n" * 100
    puts "Ihr aktueller Kontostand beträgt #{@kontostand}€."
    puts "Drücken Sie \"X\" um den folgenden Vorgang abzubrechen."
    betrag = frage("Geben sie den auszuzahlenden Betrag ein:")

    if betrag == "X"
      puts "\n" * 100
      puts "Auszahlung erfolgreich abgebrochen..."
      gets.chomp
      return main_menu
    elsif (@kontostand - betrag.to_i) >= 0
      @kontostand -= betrag.to_i
      puts "\n" * 100
      puts "Sie haben erfolgreich #{betrag}€ ausgezahlt."
      puts "Ihr neuer Kontostand beträgt #{@kontostand}€."
      gets.chomp
    else
      (@kontostand - betrag.to_i) <= 0
      puts "\n" * 100
      puts "Sie haben zu wenig Geld auf Ihrem Konto."
      puts "Bitte versuchen Sie es erneut."
      gets.chomp
      return auszahlen
    end
  end

  def kontostand_anzeigen
    puts "\n" * 100
    puts "Ihr aktueller Kontostand beträgt #{@kontostand}€"
    gets.chomp
    return main_menu
  end

  def pin_ändern
    puts "\n" * 100
    puts "Drücken Sie \"X\" um den folgenden Vorgang abzubrechen."
    alte_pin = frage("Geben sie Ihre alte PIN zur bestätigung ein:")

    if alte_pin == @pin
      puts "\n" * 100
      neue_pin1 = frage("Geben sie nun die neu gewünschte PIN ein:")
      puts "\n" * 100
      neue_pin2 = frage("Geben sie die nue gewünschte PIN zur bestätigung nochmal\'s ein:")
      if neue_pin1 == neue_pin2
        @pin = neue_pin2
        puts "\n" * 100
        puts "Sie haben Ihre PIN erfolgreich geändert."
        gets.chomp
        return main_menu
      else
        puts "\n" * 100
        puts "Ihre neu angegebene PIN ist inkorrekt."
        puts "Bitte versuchen Sie es erneut."
        gets.chomp
        return pin_ändern
      end
    elsif alte_pin == "X"
      puts "\n" * 100
      puts "Pin änderung erfolgreich abgebrochen..."
      gets.chomp
      return main_menu
    else
      puts "\n" * 100
      puts "Ihre angegebene PIN ist inkorrekt."
      puts "Bitte versuchen Sie es erneut."
      gets.chomp
      return pin_ändern
    end
  end
end
